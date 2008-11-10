Return-Path: <linux-kernel-owner+w=401wt.eu-S1755198AbYKJUgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbYKJUgN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 15:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYKJUf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 15:35:57 -0500
Received: from serrano.cc.columbia.edu ([128.59.29.6]:46769 "EHLO
	serrano.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbYKJUfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 15:35:54 -0500
Message-ID: <49189ADD.7030607@cs.columbia.edu>
Date: Mon, 10 Nov 2008 15:34:37 -0500
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v9][PATCH 05/13] Dump memory address space
References: <1226335060-7061-1-git-send-email-orenl@cs.columbia.edu> <1226335060-7061-6-git-send-email-orenl@cs.columbia.edu> <20081110201251.GA7471@us.ibm.com>
In-Reply-To: <20081110201251.GA7471@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
>> +/**
>> + * cr_fill_fname - return pathname of a given file
>> + * @path: path name
>> + * @root: relative root
>> + * @buf: buffer for pathname
>> + * @n: buffer length (in) and pathname length (out)
>> + */
>> +static char *
>> +cr_fill_fname(struct path *path, struct path *root, char *buf, int *n)
>> +{
>> +	struct path tmp = *root;
>> +	char *fname;
>> +
>> +	BUG_ON(!buf);
>> +	fname = __d_path(path, &tmp, buf, *n);
>> +	if (!IS_ERR(fname))
>> +		*n = (buf + (*n) - fname);
>> +	/*
>> +	 * FIXME: if __d_path() changed these, it must have stepped out of
>> +	 * init's namespace. Since currently we require a unified namespace
>> +	 * within the container: simply fail.
>> +	 */
>> +	if (tmp.mnt != root->mnt || tmp.dentry != root->dentry)
>> +		fname = ERR_PTR(-EBADF);
>> +
>> +	return fname;
>> +}
> 
> You still are not taking the dcache_lock around __d_path.
> 

You still are right.

Oren.
