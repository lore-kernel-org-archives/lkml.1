Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbZHKPvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbZHKPvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZHKPvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:51:15 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:47676 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZHKPvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:51:14 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz98dN14e1I1444Mzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KO7YP3-01-A20-02
X-M-MSG: 
Date: Tue, 11 Aug 2009 17:51:06 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Kevin Winchester <kjwinchester@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM
 flag
Message-ID: <20090811155106.GB16173@aftab>
References: <4A7D673A.1090401@gmail.com>
 <20090808152016.GB25374@liondog.tnic>
 <4A7E0797.7060504@gmail.com>
 <20090810131219.GD21879@aftab>
 <4A80A5AD.2000209@gmail.com>
 <19073.33348.459260.456740@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <19073.33348.459260.456740@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 11 Aug 2009 15:51:04.0637 (UTC) FILETIME=[888856D0:01CA1A9B]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 11, 2009 at 04:37:56PM +0200, Mikael Pettersson wrote:
> Since the BIOS apparently wrote some MSR to get LAHF_LM incorrectly
> reported by CPUID, would it be possible to also correct that MSR so
> that applications that execute CPUID get the correct feature flags?

That's a good catch, actually. We have to turn off that bit in the cpuid
leaf too if the CPU doesn't support the instructions so that cpuid info
is consistent. LAHF/SAHF support in 64bit mode has to be cpuid-checked
prior to using them so that info has to be correct.

@Kevin: willing to try a patch or two?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

