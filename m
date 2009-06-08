Return-Path: <linux-kernel-owner+w=401wt.eu-S1755377AbZFHMTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377AbZFHMTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZFHMTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:19:01 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:3076 "EHLO
	VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753444AbZFHMTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:19:00 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432R98dR1805Mzz1202hzzz32i6bh17ch43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KKX67F-01-M8F-01
Date: Mon, 8 Jun 2009 14:18:05 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86: Detect use of extended APIC ID for AMD
	CPUs
Message-ID: <20090608121805.GB8699@alberich.amd.com>
References: <20090604104016.GT5736@alberich.amd.com> <tip-37f36c1017f0032fa7a1fb85a0cddfc0d526d17f@git.kernel.org> <4A2C0B1B.3080502@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A2C0B1B.3080502@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 08 Jun 2009 12:18:53.0829 (UTC) FILETIME=[49F13350:01C9E833]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 11:46:51AM -0700, Yinghai Lu wrote:
> tip-bot for Andreas Herrmann wrote:
> > diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
> > index 42f2f83..9b2c049 100644
> > --- a/arch/x86/include/asm/apic.h
> > +++ b/arch/x86/include/asm/apic.h
> > @@ -410,7 +410,7 @@ static inline unsigned default_get_apic_id(unsigned long x)
> >  {
> >  	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
> >  
> > -	if (APIC_XAPIC(ver))
> > +	if (APIC_XAPIC(ver) || boot_cpu_has(X86_FEATURE_EXTD_APICID))
> >  		return (x >> 24) & 0xFF;
> >  	else
> >  		return (x >> 24) & 0x0F;
> 
> looks like we should fix APIC_XAPIC() or have one global apic_ver.

I thought to set the new flag for Intel as well and to replace
APIC_XAPIC with checks for that flag. But for some reason this was
ugly as lapic access must be configured before you can check the
APIC_VERSION and so I decided to keep Intel code as is and not to
potentially introduce regresions.


Regards,
Andreas


