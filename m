Return-Path: <linux-kernel-owner+w=401wt.eu-S1764432AbZAONoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764432AbZAONoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762132AbZAONns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:43:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47568 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762752AbZAONnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:43:47 -0500
Date: Thu, 15 Jan 2009 14:43:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Baodong Chen <chenbdchenbd@gmail.com>, trivial@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Li Yang <leo@zh-kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/x86/boot.txt:modify fieldname
Message-ID: <20090115134337.GA4688@elte.hu>
References: <d204e3110901080324g161c51cdo8dd4105e2c365cb4@mail.gmail.com> <alpine.LNX.1.10.0901151332380.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901151332380.5377@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3341]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 8 Jan 2009, Baodong Chen wrote:
> 
> > >From a7f7081367c5682c8a0b7fd0699a7bff9e779fc7 Mon Sep 17 00:00:00 2001
> > From: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
> > Date: Wed, 7 Jan 2009 21:54:00 +0800
> > Subject: [PATCH] Documentation/x86/boot.txt:modify fieldname
> >  start_sys was changed to start_sys_seg
> >  iinitrd_addr_max was changed to ramdisk_max
> >  pad2 was changed to pad2 and pad3
> >  readmode_swtch was changed to realmode_swtch
> >  Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>
> > 
> > ---
> >  Documentation/x86/boot.txt |   13 +++++++------
> >  1 files changed, 7 insertions(+), 6 deletions(-)
> > 
> > diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> > index 7b4596a..1229969 100644
> > --- a/Documentation/x86/boot.txt
> > +++ b/Documentation/x86/boot.txt
> > @@ -158,7 +158,7 @@ Offset	Proto	Name		Meaning
> >  0202/4	2.00+	header		Magic signature "HdrS"
> >  0206/2	2.00+	version		Boot protocol version supported
> >  0208/4	2.00+	realmode_swtch	Boot loader hook (see below)
> > -020C/2	2.00+	start_sys	The load-low segment (0x1000) (obsolete)
> > +020C/2	2.00+	start_sys_seg	The load-low segment (0x1000) (obsolete)
> >  020E/2	2.00+	kernel_version	Pointer to kernel version string
> >  0210/1	2.00+	type_of_loader	Boot loader identifier
> >  0211/1	2.00+	loadflags	Boot protocol option flags
> > @@ -170,10 +170,11 @@ Offset	Proto	Name		Meaning
> >  0224/2	2.01+	heap_end_ptr	Free memory after setup end
> >  0226/2	N/A	pad1		Unused
> >  0228/4	2.02+	cmd_line_ptr	32-bit pointer to the kernel command line
> > -022C/4	2.03+	initrd_addr_max	Highest legal initrd address
> > +022C/4	2.03+	ramdisk_max	Highest legal initrd address
> >  0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
> >  0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
> > -0235/3	N/A	pad2		Unused
> > +0235/1	N/A	pad2		Unused
> > +0236/2	N/A	pad3		Unused
> >  0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
> >  023C/4	2.07+	hardware_subarch Hardware subarchitecture
> >  0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
> > @@ -299,14 +300,14 @@ Protocol:	2.00+
> >    e.g. 0x0204 for version 2.04, and 0x0a11 for a hypothetical version
> >    10.17.
> > 
> > -Field name:	readmode_swtch
> > +Field name:	realmode_swtch
> >  Type:		modify (optional)
> >  Offset/size:	0x208/4
> >  Protocol:	2.00+
> > 
> >    Boot loader hook (see ADVANCED BOOT LOADER HOOKS below.)
> > 
> > -Field name:	start_sys
> > +Field name:	start_sys_seg
> >  Type:		read
> >  Offset/size:	0x20c/2
> >  Protocol:	2.00+
> > @@ -468,7 +469,7 @@ Protocol:	2.02+
> >    zero, the kernel will assume that your boot loader does not support
> >    the 2.02+ protocol.
> > 
> > -Field name:	initrd_addr_max
> > +Field name:	ramdisk_max
> >  Type:		read
> >  Offset/size:	0x22c/4
> >  Protocol:	2.03+
> 
> This one doesn't seem to have been picked up by x86 maintainers ... guys, 
> could anyone please Ack it, so that i can take it through trivial tree, or 
> take it through x86 tree?
> 
> Thanks,

applied to tip/x86/doc (added your Ack line as well), thanks guys!

	Ingo
