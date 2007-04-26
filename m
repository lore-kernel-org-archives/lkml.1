Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbXDZBCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbXDZBCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXDZBCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:02:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:13244 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbXDZBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:02:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jz2CVSqmDNisN5Fl/a4DFJvNwZOufJLni838JLmDgjqKfRsraSubA8z3YHLqGsEWpTr9OWFfyEaqwlAaXG9t6aNkADU/SP/fPfP50BLDV/qdqTD9rGLQIClE8noDepb4I2L8JkhediOXJmRa4Zq5aFQL97huUMfAEFuXYtd35V4=
Subject: Re: Nonfunctional ethernet (was Re: 2.6.21-rc7-mm1 +
	sysfs-oops-workaround.patch -- INFO: possible recursive locking detected)
From: "Antonino A. Daplas" <adaplas@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1177544702.4668.9.camel@daplas>
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>
	 <462EE4B7.6000708@gmail.com>  <1177512528.4856.15.camel@daplas>
	 <1177544702.4668.9.camel@daplas>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 09:02:02 +0800
Message-Id: <1177549323.4685.3.camel@daplas>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 07:45 +0800, Antonino A. Daplas wrote:
> On Wed, 2007-04-25 at 22:48 +0800, Antonino A. Daplas wrote:
> > On Wed, 2007-04-25 at 14:18 +0900, Tejun Heo wrote:
> > > Miles Lane wrote:
> 
> > eth0 renamed to eth54
> > BUG: atomic counter underflow at:
> >  [<c0104378>] show_trace_log_lvl+0x1a/0x30
> >  [<c0104ec9>] show_trace+0x12/0x14
> >  [<c0104f22>] dump_stack+0x16/0x18
> >  [<c01bd575>] _atomic_dec_and_lock+0x29/0x4c
> >  [<c0174388>] dput+0x34/0x103
> >  [<c019d181>] sysfs_drop_dentry+0x141/0x149
> >  [<c019d212>] sysfs_hash_and_remove+0x89/0x10e
> >  [<c019f1fc>] sysfs_remove_link+0xe/0x10
> >  [<c0221839>] device_rename+0x110/0x181
> >  [<c025420a>] dev_change_name+0x11e/0x1ca
> >  [<c02545e6>] dev_ifsioc+0x330/0x3d7
> >  [<c0254d25>] dev_ioctl+0x350/0x46e
> >  [<c0249792>] sock_ioctl+0x1be/0x1ca
> >  [<c016f3c0>] do_ioctl+0x1c/0x53
> >  [<c016f5e3>] vfs_ioctl+0x1ec/0x203
> >  [<c016f643>] sys_ioctl+0x49/0x62
> >  [<c0103cde>] sysenter_past_esp+0x5f/0x99
> >  =======================
> 
> The above tracing was caused by CONFIG_SYSFS_DEPRECATED=y and by setting
> this to n, the tracing disappeared..  Still, all my network cards are
> non-functional.  Entries in /sys/class/net are bogus:
> 
> / # cd /sys/class/net/
> /sys/class/net # ls
> eth1  eth44  eth54  lo
> 
> /sys/class/net # cd eth1
> -bash: cd: eth1: No such file or directory
> 
> /sys/class/net # ls -l eth1
> lrwxrwxrwx 1 root root 0 Apr 26 07:15 eth1 ->
> ../../devices/pci0000:00/0000:00:12.0/net/eth0
> 
> /sys/class/net # cd ../../devices/pci0000\:00/0000\:00\:12.0/net/eth0
> -bash: cd: ../../devices/pci0000:00/0000:00:12.0/net/eth0: No such file
> or directory
> 
> Do you know of any patches I need to revert/apply?  Anyway, I have to
> boot back to this kernel and find out more what's going on.
> 

More info.

I can bring up the network manually using ifconfig.  It's opensuse's
rcnetwork script that fails to bring the network up. Entries
in /sys/class/net are still bogus.

This kernel is now usable to me, I'll start bisection later today if
nobody has an answer.

Tony 

