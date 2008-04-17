Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbYDQTt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbYDQTt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYDQTts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:49:48 -0400
Received: from nn7.de ([85.214.94.156]:39891 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbYDQTtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:49:47 -0400
Subject: Re: [Suspend-devel] 2.6.25-rc6 regression - hang on resume
	[Bug	10319]
From: Soeren Sonnenburg <kernel@nn7.de>
To: Stefan Seyfried <seife@suse.de>
Cc: Romano Giannetti <romanol@upcomillas.es>,
       "Rafael J\. Wysocki" <rjw@sisk.pl>, suspend-devel@lists.sourceforge.net,
       Jesse Barnes <jesse.barnes@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <480794D4.9020503@suse.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik>
	 <pdYe6zNQVl.A.fp.nEW9HB@albercik> <1207290689.4511.1.camel@localhost>
	 <1207552602.26185.13.camel@pern>  <480794D4.9020503@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 17 Apr 2008 21:49:40 +0200
Message-Id: <1208461780.17078.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-17 at 20:20 +0200, Stefan Seyfried wrote:
> Romano Giannetti schrieb:
> > 
> > On Fri, 2008-04-04 at 08:31 +0200, Soeren Sonnenburg wrote:
> >> On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
> > 
> >>> Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=10319
> >>> Subject             : 2.6.25-rc6 regression - hang on resume
> >>> Submitter   : Soeren Sonnenburg <kernel@nn7.de>
> >>> Date                : 2008-03-25 04:44 (10 days old)
> >> Yes. The machine resumes and display stays black using s2ram -f -p
> >> (blindly typing reboot etc on keyboard does what is expected).
> However
> >> display comes back on 2.6.24.
> > 
> > I can add that on my laptop (toshiba U305, Intel 945GM chipset),
> s2ram
> > -f -p -m which used to work ok, in X and console, in 2.6.24 stopped
> to
> > work (I tested -rc8, but I think it's like that since a long time).
> > Machine resumes but the screen stays off after that, although
> machine is
> > working (exactly as Soeren said). 
> 
> can you try if this patch to libx86 (make sure it gets installed and
> used...)
> fixes the problem?

for me it won't (core 1 duo), not clear whether his toshiba is a core 2
duo though supporting that flag...

anyway I tried again with the patch and 2.6.25 and same thing, display
stays black on console. then i s2ram'd again and - the display came
back!!

all my further attempts never made it come back... however from inside X
it works now (radeonhd...).

> Index: libx86-0.99/x86-common.c
> ===================================================================
> --- libx86-0.99.orig/x86-common.c
> +++ libx86-0.99/x86-common.c
> @@ -232,7 +232,7 @@ int LRMI_common_init(void)
>         }
> 
>         m = mmap((void *)0xa0000, 0x100000 - 0xa0000,
> -        PROT_READ | PROT_WRITE,
> +        PROT_READ | PROT_WRITE | PROT_EXEC,
>          MAP_FIXED | MAP_SHARED, fd_mem, 0xa0000);
> 
>         if (m == (void *)-1) {
> 
> > On the other hand, now the plain "echo mem > /sys/power/state" works
> > perfectly, from X and console. So some of the magic vbe save/restore
> of
> > s2ram mess something up for this card. 
> 
> Especially the userspace stuff (VBE_*) should not interfere with the
> restoring
> now done inside the kernel drivers.

Hmmhh maybe when the radeon(hd) fb driver enters the kernel it will work
for me nicely again...

Soeren
