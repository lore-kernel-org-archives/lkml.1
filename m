Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZHKQCH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZHKQCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:02:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZHKQCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:02:06 -0400
Received: from mail-yw0-f191.google.com ([209.85.211.191]:45698 "EHLO
	mail-yw0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbZHKQCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:02:05 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Aug 2009 12:02:05 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=le2hzJaFxiHMlNTZWrmx1RF9PC7/UqKUkc7avtWddDN2VR0Hy/YX8pC+upkzAuLALu
         9KBMxLnatZUPmqaoWAqApjttEq4Hik576qnrns3ifugyRPlJc05Hp9MEzDBUGWFjqFqc
         Cq8gQRv54IpPdU5ifuCiokK8RgewtyHrZvPnA=
MIME-Version: 1.0
In-Reply-To: <20090811155106.GB16173@aftab>
References: <4A7D673A.1090401@gmail.com> <20090808152016.GB25374@liondog.tnic>
	 <4A7E0797.7060504@gmail.com> <20090810131219.GD21879@aftab>
	 <4A80A5AD.2000209@gmail.com>
	 <19073.33348.459260.456740@pilspetsen.it.uu.se>
	 <20090811155106.GB16173@aftab>
Date: Tue, 11 Aug 2009 12:55:03 -0300
Message-ID: <d1af83620908110855x75b1e5aeq6d814ca90c49ec22@mail.gmail.com>
Subject: Re: [PATCH v3] x86: clear incorrectly forced X86_FEATURE_LAHF_LM flag
From: Kevin Winchester <kjwinchester@gmail.com>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>,
       Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/11 Borislav Petkov <borislav.petkov@amd.com>:
> On Tue, Aug 11, 2009 at 04:37:56PM +0200, Mikael Pettersson wrote:
>> Since the BIOS apparently wrote some MSR to get LAHF_LM incorrectly
>> reported by CPUID, would it be possible to also correct that MSR so
>> that applications that execute CPUID get the correct feature flags?
>
> That's a good catch, actually. We have to turn off that bit in the cpuid
> leaf too if the CPU doesn't support the instructions so that cpuid info
> is consistent. LAHF/SAHF support in 64bit mode has to be cpuid-checked
> prior to using them so that info has to be correct.
>
> @Kevin: willing to try a patch or two?
>

Sure, I'll give it a try this evening.  I assume that since Erratum 110 says:

--------------------------
Suggested Workaround
For processors which support the feature (as determined by the
processor revision ID), BIOS should
write a one to:
• MSR C001_100Dh, bit 32 for revision D silicon.
• MSR C001_1005h, bit 32 for revision E and later silicon.
This will cause the extended feature flag in ECX[0] to be set.
--------------------------

That writing a zero to those same MSRs would clear the feature flag?

-- 
Kevin Winchester
