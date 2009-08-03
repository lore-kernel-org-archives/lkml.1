Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbZHCS1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbZHCS1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbZHCS1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:27:01 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57224 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZHCS1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:27:00 -0400
Date: Mon, 3 Aug 2009 13:26:40 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Oren Laadan <orenl@librato.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Pavel Emelyanov <xemul@openvz.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [RFC v17][PATCH 16/60] pids 6/7: Define do_fork_with_pids()
Message-ID: <20090803182640.GB7493@us.ibm.com>
References: <1248256822-23416-1-git-send-email-orenl@librato.com> <1248256822-23416-17-git-send-email-orenl@librato.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248256822-23416-17-git-send-email-orenl@librato.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oren Laadan (orenl@librato.com):
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
...
> +struct target_pid_set {
> +	int num_pids;
> +	pid_t *target_pids;
> +};

Oren, I thought you had decided to add an extended flags field
here, to support additional CLONE_ flags - such as CLONE_TIMENS?

I mention it now because if you're still considering that
long-term, then IMO the syscall should not be called clone_with_pids(),
but clone_extended().  Otherwise, to support new clone flags we'll
either have to use unshare2 (without clone support), or add yet
another clone variant, OR use clone_with_pids() which is a poor name
for something which will likely be used in cases without specifying
pids, but specifying flags not support through any other interface.

-serge
