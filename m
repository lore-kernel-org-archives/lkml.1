Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZGHOpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZGHOpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 10:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZGHOo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 10:44:56 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54494 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbZGHOoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 10:44:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Y8nJn/fwEsWEgyXxgcyBiYTB/10aQ0V+SWRhsB1e5ZHX7Y0ZhwCeEKKcZQZCzb5lcP
         2E/5x+9QtRwnk7svMl0X73fS4q4TAATzIe2/K0OOj4lqg4HfC4brYNjmCxrg2Xd/inRt
         uV8GlBWGY9u1M/rDe99rV4j1Ic6VeQ0co4UPw=
Date: Wed, 8 Jul 2009 18:44:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
Message-ID: <20090708144452.GB5301@lenovo>
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org> <4A50E323.6060109@zytor.com> <alpine.LFD.2.00.0907080023470.13862@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907080023470.13862@eddie.linux-mips.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maciej W. Rozycki - Wed, Jul 08, 2009 at 12:49:11AM +0100]
| On Sun, 5 Jul 2009, H. Peter Anvin wrote:
| 
| > >  How do you set cpu_has_apic for systems with discrete local APICs?  The 
| > > CPUID flag is not set in this case.
| > > 
| > 
| > Well, should it be?  We do set flags when they're appropriate to us, and
| > if the semantics are such as that is inappropriate we can set a custom bit.
| 
|  Hmm, that might simplify things here and there and the less special cases 
| in code -- and thus effort needed -- for the discrete APIC, the better.  
| I think there is no reason why it couldn't be done -- all the places which 
| need version-specific APIC features have to check the LVR register anyway.  
| And the availability of the APICBASE MSR has to be validated separately 
| too as it comes with P6+ only.
| 
|  The only place which could care I believe is code to set X86_FEATURE_11AP 
| -- this should obviously be disabled for the discrete APIC as it is now, 
| as the chip does not suffer from the erratum and the workaround is costly 
| performance-wise.  That piece of code would have to be checked -- I don't 
| know what the order of setting of these bits would be and thus if one 
| could affect the other.  The dependency would better be well documented 
| then too -- my observation is the knowledge about the APIC subsystem among 
| people typically only covers a narrow subset of implementations.
| 
|   Maciej
| 

Thanks a lot for hints, Maciej! I've had an idea to set this bit
in verify_local_APIC (or something like that) since at this point
if discrete APIC happens -- we already complained in case of APIC
related BIOS problems. So that check-point should be safe. Anyway,
will recheck and put a big comment into patch.

	-- Cyrill
