Return-Path: <linux-kernel-owner+w=401wt.eu-S1752204AbYKJUNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbYKJUNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbYKJUNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:13:01 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34842 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYKJUNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:13:00 -0500
Date: Mon, 10 Nov 2008 14:12:51 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@cs.columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v9][PATCH 05/13] Dump memory address space
Message-ID: <20081110201251.GA7471@us.ibm.com>
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu> <1226335060-7061-6-git-send-email-orenl@cs.columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226335060-7061-6-git-send-email-orenl@cs.columbia.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@cs.columbia.edu):
> +/**
> + * cr_fill_fname - return pathname of a given file
> + * @path: path name
> + * @root: relative root
> + * @buf: buffer for pathname
> + * @n: buffer length (in) and pathname length (out)
> + */
> +static char *
> +cr_fill_fname(struct path *path, struct path *root, char *buf, int *n)
> +{
> +	struct path tmp = *root;
> +	char *fname;
> +
> +	BUG_ON(!buf);
> +	fname = __d_path(path, &tmp, buf, *n);
> +	if (!IS_ERR(fname))
> +		*n = (buf + (*n) - fname);
> +	/*
> +	 * FIXME: if __d_path() changed these, it must have stepped out of
> +	 * init's namespace. Since currently we require a unified namespace
> +	 * within the container: simply fail.
> +	 */
> +	if (tmp.mnt != root->mnt || tmp.dentry != root->dentry)
> +		fname = ERR_PTR(-EBADF);
> +
> +	return fname;
> +}

You still are not taking the dcache_lock around __d_path.

-serge
