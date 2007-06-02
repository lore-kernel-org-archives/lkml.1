Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbXFBOp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbXFBOp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759680AbXFBOpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:45:19 -0400
Received: from mo-p07-ob.rzone.de ([81.169.146.188]:8248 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509AbXFBOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:45:18 -0400
Date: Sat, 2 Jun 2007 16:45:15 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: OOPS (NULL pointer dereference) in v2.6.22-rc3
Message-ID: <20070602144515.GA2390@steel.home>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
Mail-Followup-To: Alex Riesen <raa.lkml@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070601221515.GA6673@steel.home> <20070602013502.a20ad424.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070602013502.a20ad424.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-RZG-AUTH: z4gQVF2k5XWuW3Ccul2hcNmRtBQ=
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton, Sat, Jun 02, 2007 10:35:02 +0200:
> On Sat, 2 Jun 2007 00:15:15 +0200 Alex Riesen <raa.lkml@gmail.com> wrote:
> 
> > Ubuntu 7.04, P4, SMT, hyperthreading active. Not reproducable, context unknown,
> > seen only two times :(
> > 
> > kernel: Call Trace:
> > kernel:  [show_trace_log_lvl+26/47] show_trace_log_lvl+0x1a/0x2f
> > kernel:  [show_stack_log_lvl+157/165] show_stack_log_lvl+0x9d/0xa5
> > kernel:  [show_registers+441/651] show_registers+0x1b9/0x28b
> > kernel:  [die+273/530] die+0x111/0x212
> > kernel:  [do_page_fault+1060/1266] do_page_fault+0x424/0x4f2
> > kernel:  [error_code+114/120] error_code+0x72/0x78
> > kernel:  [vfs_ioctl+562/581] vfs_ioctl+0x232/0x245
> > kernel:  [sys_ioctl+49/72] sys_ioctl+0x31/0x48
> > kernel:  [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
> 
> I think we've seen a report of that before.  Do you recall what the system
> was doing at the time?
> 

Not really. One time it was when I started an old Opera browser I
discovered somewhere in my $HOME, the other is believe when I was
playing a scratched DVD with vlc (not sure, though).

> +		if (!filp->f_op->ioctl) {
> +			printk("%s: ioctl %p disappeared\n", __FUNCTION__, f);

Applied, but used KERN_EMERG (let's hope there will be no storm).

