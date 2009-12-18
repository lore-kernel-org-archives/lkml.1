Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbZLRS7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbZLRS7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZLRS7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:59:05 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:39485 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZLRS7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:59:02 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 18 Dec 2009 10:59:00 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Roland Dreier <rdreier@cisco.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] anonfd: Make file read-only if fops->write is not
 set
In-Reply-To: <adak4wk2n97.fsf_-_@roland-alpha.cisco.com>
Message-ID: <alpine.DEB.2.00.0912181057040.24513@makko.or.mcafeemobile.com>
References: <adaws0k3kd8.fsf@roland-alpha.cisco.com> <20091218061049.GI18217@ZenIV.linux.org.uk> <adak4wk2n97.fsf_-_@roland-alpha.cisco.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009, Roland Dreier wrote:

> It seems a couple places such as arch/ia64/kernel/perfmon.c and
> drivers/infiniband/core/uverbs_main.c could use anon_inode_getfile()
> instead of a private pseudo-fs + alloc_file(), if only there were a way
> to get a read-only file.  So provide this by having anon_inode_getfile()
> create a read-only file if the fops->write passed in is NULL.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
>  > Good grief, what for?  We are already passing O_NDELAY in flags argument,
>  > why not add O_RDWR/O_RDONLY to it?  It's not as if we had that many
>  > callers, after all...
> 
> fair enough, I wasn't sure if I really liked changing the meaning of the
> flags argument without any indication of that in the function signature,
> but definitely the code is nicer.
> 
> so would something like this make sense?  if so I'll send follow-ups
> converting ia64 / perfmon and infiniband / uverbs to anon_inodes.

Looks OK to me.


- Davide


