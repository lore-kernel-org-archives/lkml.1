Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbXI0TtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbXI0TtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 15:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759852AbXI0TtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 15:49:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758373AbXI0TtM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 15:49:12 -0400
Date: Thu, 27 Sep 2007 12:48:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>
Subject: Re: 2.6.23-rc8-mm2: BUG near reiserfs_xattr_set
Message-Id: <20070927124833.d2691813.akpm@linux-foundation.org>
In-Reply-To: <46FC021F.8060109@free.fr>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	<46FC021F.8060109@free.fr>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007 21:18:55 +0200
Laurent Riffard <laurent.riffard@free.fr> wrote:

> Le 27.09.2007 11:22, Andrew Morton a écrit :
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> 
> I've got this BUG a few seconds after I logged in into Gnome desktop :
> 
> [partially hand copied BUG]
> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
> printing eip: c016f55e *pde=0b8a5067 *pte=00000000
> Oops: 0002 [#1] PREEMPT
> ...
> Process beagled...
> ...
> Call Trace:
>  __fput+0x124/0x1a9
>  fput+0x31/0x35
>  reiserfs_xattr_set+0x291/0x2b0 [reiserfs]
>  user_set+0x4c/0x57 [reiserfs]
>  reiserfs_setxattr+0x81/0xf1 [reiserfs]
>  vfs_setxattr+0x7d/0xfa
>  setxattr+0xb9/0xd1
>  sys_lsetxattr+0x4c/0x85
>  sysenter_past_esp+0x57/0x85
> 
> EIP: mnt_drop_write+0x5b/0x9d
> 

Hi, Dave!

> It's fully reproducible.
> 
> /home is mounted with the following options:
>    /dev/mapper/vglinux1-lvhome on /home type reiserfs (rw,noatime,nodiratime,user_xattr)
> 
> This BUG happened with rc8-mm1 too.
> rc6-mm1 works fine.
> I didn't try rc7-mm1.
> 
> .config attached.
> ~~
> laurent
> 
