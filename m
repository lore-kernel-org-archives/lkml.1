Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbXHBJ6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbXHBJ6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 05:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbXHBJ6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 05:58:25 -0400
Received: from mail.suse.de ([195.135.220.2]:50221 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbXHBJ6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 05:58:24 -0400
Subject: Re: 2.6.22 regression: thermal trip points
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Adrian =?ISO-8859-1?Q?Schr=F6ter?= <adrian@suse.de>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, pavel@ucw.cz, mjg59@srcf.ucam.org,
       lenb@kernel.org, "Zhang, Rui" <rui.zhang@intel.com>,
       Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>
In-Reply-To: <200708021145.09377.adrian@suse.de>
References: <46B1988C.3090302@t-online.de>
	 <1186047747.18821.450.camel@queen.suse.de>
	 <200708021145.09377.adrian@suse.de>
Content-Type: text/plain; charset=utf-8
Organization: Novell/SUSE
Date: Thu, 02 Aug 2007 11:58:21 +0200
Message-Id: <1186048701.18821.459.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-02 at 11:45 +0200, Adrian Schröter wrote:
> On Thursday 02 August 2007 11:42:27 wrote Thomas Renninger:
> > On Thu, 2007-08-02 at 10:40 +0200, Knut Petersen wrote:
> > > Hi everybody!
> > >
> > > Kernel 2.6.22 decreases performance by about 50% on my system.
> > > No, I do not like that. The reason is a broken BIOS, granted, but there
> > > was a perfect workaround in the kernel that has been dropped.
> > >
> > > mainboard: AOpen i915GMm-hfs, AWARD BIOS
> > > cpu: Pentium-M 750 (0.8 to 1.86 MHz)
> > > openSuSE 10.2 with kernel 2.6.22.1
> >
> > Is this a DELL laptop that gets throttled by 75% to throttling state 6
> > if 60 degrees are exceeded?
> > Adrian has such a machine..., no idea what is going on with that one,
> > but only workaround to get any use out of this machine is to override at
> > least the passive trip point.
> 
> JFYI, there are plenty of these systems around, it was one out of four 
> standard Novell modells. I am mabye just the first one who uses Factory on 
> it, but expect more bugreports when 10.3 gets released ...

Oops. So this is not broken HW/BIOS, but definitely a kernel problem?
Only idea that comes to my mind finding this is to grep through the DSDT
and look out for code that accesses CPU throttling HW ports. Maybe ACPI
subsystem gets something wrong, processing this code and activating
throttling by accident?

Anyway, only solution/workaround to use these machines with current
kernels is to override trip points, maybe the patch should really just
be reverted...

   Thomas 

