Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYG2SSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYG2SSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYG2SSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:18:09 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44963 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbYG2SSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:18:07 -0400
Date: Tue, 29 Jul 2008 12:17:51 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, mpm@selenic.com,
       akpm@linux-foundation.org
Subject: Re: [patch 2/4] Configure out file locking features
Message-ID: <20080729181751.GA24924@parisc-linux.org>
References: <20080729154520.728594017@free-electrons.com>> <20080729154747.872888047@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729154747.872888047@free-electrons.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 05:45:22PM +0200, Thomas Petazzoni wrote:
> This patch adds the CONFIG_FILE_LOCKING option which allows to remove
> support for advisory locks. With this patch enabled, the flock()
> system call, the F_GETLK, F_SETLK and F_SETLKW operations of fcntl()
> and NFS support are disabled. These features are not necessarly needed
> on embedded systems. It allows to save ~11 Kb of kernel code and data:
> 
>    text	   data	    bss	    dec	    hex	filename
> 1125436	 118764	 212992	1457192	 163c28	vmlinux.old
> 1114299	 118564	 212992	1445855	 160fdf	vmlinux
>  -11137    -200       0  -11337   -2C49 +/-
> 
> This patch has originally been written by Matt Mackall
> <mpm@selenic.com>, and is part of the Linux Tiny project.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

In principle, I think this is a great idea.

>  config NFS_FS
>  	tristate "NFS client support"
> -	depends on INET
> +	depends on INET && FILE_LOCKING
>  	select LOCKD
>  	select SUNRPC
>  	select NFS_ACL_SUPPORT if NFS_V3_ACL

I think this part is a little lazy.  It should be possible to support
NFS without file locking.  I suspect that's really not in-scope for the
linux-tiny tree as currently envisaged with the focus on embedded
devices that probably don't use NFS anyway.  Do we want to care about
the situation of a machine with fixed workload, that doesn't need file
locking, but does use NFS?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
