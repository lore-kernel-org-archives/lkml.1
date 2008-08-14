Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYHNJKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYHNJKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 05:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYHNJKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 05:10:38 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:11623 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbYHNJKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 05:10:37 -0400
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fQzz10dck10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K5L2TE-01-I82-01
Subject: Re: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700
	platform
From: crane cai <crane.cai@amd.com>
Reply-To: crane.cai@amd.com
To: Ingo Molnar <mingo@elte.hu>
CC: vojtech@suse.cz, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       XiaoGang Zheng <gang.zheng@amd.com>
In-Reply-To: <20080814084129.GA1650@elte.hu>
References: <1218683616.20466.13.camel@crane-laptop>
	 <20080814084129.GA1650@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: AMD
Date: Thu, 14 Aug 2008 17:10:24 +0800
Message-ID: <1218705024.5646.17.camel@crane-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-OriginalArrivalTime: 14 Aug 2008 09:10:25.0300 (UTC) FILETIME=[966F1D40:01C8FDED]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-08-14 at 10:41 +0200, Ingo Molnar wrote:
> * crane cai <crane.cai@amd.com> wrote:
> 
> > >From 9bd2f534f986768f1944e626e37af1c323e47dbb Mon Sep 17 00:00:00 2001
> > From: Crane Cai <crane.cai@amd.com>
> > Date: Thu, 14 Aug 2008 10:31:01 +0800
> > Subject: [PATCH] HPET: Workaround for a BIOS workaround on AMD SB700 platform
> > 
> > On the AMD SB700 southbridge, between the revisions 0x30 to 0x3a, when 
> > its spread-spectrum frequency modulation feature is enabled, the base 
> > frequency used by the HPET will not be running on average slower than 
> > nominal 14.318 MHz.
> >
> > Since there is no provision in the OS for HPET to work with properly 
> > with slower frequency, the BIOS on this platform uses SMM to emulate 
> > accesses to the HPET config register to supply a corrected base 
> > frequency to compensate for it.
> >
> > However, due to the implementation of the SMM BIOS code, there is a 
> > time window after the first access to the HPET, which triggers 
> > initialization of the SMM code, in which the HPET isn't available. 
> > Thus it's necessary to wait until the HPET emulation is ready, and 
> > this is what the patch does on the affected machines.
> 
> nice fix! I've applied it to tip/x86/urgent as the quirk is limited to 
> this platform so it should be safe for v2.6.27 as well.
> 
> Exactly what kind of failure mode have you seen without the quirk? Do we 
> read out the wrong values and thus hpet_clocksource_register() is 
> calibrated incorrectly and you can get non-functional high-res timers? 
> Have you seen hangs/crashes due to that, or incorrect timings?
System might loop in TSC calibration in booting. System tick can not correctly set.

> > Signed-off-by: XiaoGang Zheng <gang.zheng@amd.com>
> > Signed-off-by: Crane Cai <crane.cai@amd.com>
> 
> A quick question: the signoff order indicates that the patch has been 
> authored by XiaoGang Zheng. Or is the reverse order intended? (you wrote 
> the patch and XiaoGang Zheng processed it further)
XiaoGang insures that HPET check method in hardware view.
I refine the method and generate the patch.
Vojtech and Zahir refine the description.
This issue is cleared by Joachim and many other persons in SUSE.
Thanks all.

> 
> 	Ingo
> 

-Crane

