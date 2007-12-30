Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXL3VCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXL3VCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 16:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXL3VCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 16:02:34 -0500
Received: from xabean.com ([67.18.92.146]:41312 "EHLO mail.xabean.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbXL3VCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 16:02:33 -0500
X-HD-DVD-Key: 09f911029d74e35bd84156c5635688c0 (blow me MPAA)
X-Envelope-From: richard@richardharman.com
X-DomainKeys: Sendmail DomainKeys Filter v0.3.0 mail.xabean.com lBUL1Q2v016454
DomainKey-Signature: a=rsa-sha1; s=beta; d=richardharman.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:content-transfer-encoding;
	b=KEOh/fWKg0/ZjTcIfH0FRwCT6efnm21HD3ERLa/rrSrV0dQ8mfxMcj/LODnkbNb4Z
	Xxjm3JaI9apiPQ44NTMig==
X-Client-Addr: 72.83.150.24
X-mtfnpy: !!MTFNPY!!
Message-ID: <47780657.8020208@richardharman.com>
Date: Sun, 30 Dec 2007 15:57:59 -0500
From: Richard Harman <richard@richardharman.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
CC: pharon@gmail.com, Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
References: <47765D11.2040903@reed.com>	<1198967334.5049.3.camel@iamer-laptop>	<4776F6A0.9010801@keyaccess.nl>	<1198979361.11150.2.camel@iamer-laptop> <20071230121725.11d05099@linux360.ro>
In-Reply-To: <20071230121725.11d05099@linux360.ro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eduard-Gabriel Munteanu wrote:
> On Sun, 30 Dec 2007 03:49:21 +0200
> 
> Note that this problem is only related to AMD64 multi-core laptops. As
> far as I can see, devs might not invest much coding effort into this
> and instead say "Go buy an Intel laptop!", as this really is a hardware
> quirk. And if Andi Kleen is correct, this is not just a laptop vendors'
> problem, but AMD itself doesn't offer support for higher C-states.
> 

I think I may have a monkey wrench to throw into this, I finally got 
around to testing the C1E patch, and the port80 patch.  End result: 
port80 patch has zero effect on this laptop, and the C1E patch makes it 
stable.

AMD C1E patch 'force_amd_c1e' (disabling the workaround):

hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
Time: hpet clocksource has been installed.
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 0
Clockevents: could not switch to one-shot mode: lapic is not functional.
Could not switch to high resolution mode on CPU 1

And with the C1E workaround enabled, the kernel doesn't whine that the 
lapic isn't functional.

Those were the kernel messages I was trying to paste in my earlier 
message, saying that the lapic works.  Do I have a DV6000 laptop that is 
a strange beast all in itself?
