Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZHKQBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZHKQBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZHKQBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:01:31 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:29917 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZHKQBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:01:30 -0400
X-SpamScore: -25
X-BigFish: VPS-25(zz1432R98dN936eM14e1I1444M12b6izz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 7,
X-WSS-ID: 0KO7Z60-04-A1F-01
Date: Tue, 11 Aug 2009 18:01:16 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Kevin Winchester <kjwinchester@gmail.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090811160116.GD16173@aftab>
References: <4A7D673A.1090401@gmail.com>
 <20090808152016.GB25374@liondog.tnic>
 <4A7E0797.7060504@gmail.com>
 <20090810131219.GD21879@aftab>
 <4A80A5AD.2000209@gmail.com>
 <19073.33348.459260.456740@pilspetsen.it.uu.se>
 <20090811155106.GB16173@aftab>
 <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Aug 2009 16:01:14.0890 (UTC) FILETIME=[F4458EA0:01CA1A9C]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 12:55:03PM -0300, Kevin Winchester wrote:
> 2009/8/11 Borislav Petkov <borislav.petkov@amd.com>:
> > On Tue, Aug 11, 2009 at 04:37:56PM +0200, Mikael Pettersson wrote:
> >> Since the BIOS apparently wrote some MSR to get LAHF_LM incorrectly
> >> reported by CPUID, would it be possible to also correct that MSR so
> >> that applications that execute CPUID get the correct feature flags?
> >
> > That's a good catch, actually. We have to turn off that bit in the cpuid
> > leaf too if the CPU doesn't support the instructions so that cpuid info
> > is consistent. LAHF/SAHF support in 64bit mode has to be cpuid-checked
> > prior to using them so that info has to be correct.
> >
> > @Kevin: willing to try a patch or two?
> >
> 
> Sure, I'll give it a try this evening.  I assume that since Erratum 110 says:
> 
> --------------------------
> Suggested Workaround
> For processors which support the feature (as determined by the
> processor revision ID), BIOS should
> write a one to:
> • MSR C001_100Dh, bit 32 for revision D silicon.
> • MSR C001_1005h, bit 32 for revision E and later silicon.
> This will cause the extended feature flag in ECX[0] to be set.
> --------------------------
> 
> That writing a zero to those same MSRs would clear the feature flag?

Yep :). Patch coming up...

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

