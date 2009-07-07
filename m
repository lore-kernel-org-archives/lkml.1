Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbZGGXtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbZGGXtW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 19:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZGGXtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 19:49:15 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:57676 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbZGGXtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 19:49:15 -0400
Date: Wed, 8 Jul 2009 00:49:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Cyrill Gorcunov <gorcunov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC -tip] x86,apic -- reduce disable_apic usage
In-Reply-To: <4A50E323.6060109@zytor.com>
Message-ID: <alpine.LFD.2.00.0907080023470.13862@eddie.linux-mips.org>
References: <20090705162044.GC4791@lenovo> <alpine.LFD.2.00.0907051737100.13862@eddie.linux-mips.org> <4A50E323.6060109@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009, H. Peter Anvin wrote:

> >  How do you set cpu_has_apic for systems with discrete local APICs?  The 
> > CPUID flag is not set in this case.
> > 
> 
> Well, should it be?  We do set flags when they're appropriate to us, and
> if the semantics are such as that is inappropriate we can set a custom bit.

 Hmm, that might simplify things here and there and the less special cases 
in code -- and thus effort needed -- for the discrete APIC, the better.  
I think there is no reason why it couldn't be done -- all the places which 
need version-specific APIC features have to check the LVR register anyway.  
And the availability of the APICBASE MSR has to be validated separately 
too as it comes with P6+ only.

 The only place which could care I believe is code to set X86_FEATURE_11AP 
-- this should obviously be disabled for the discrete APIC as it is now, 
as the chip does not suffer from the erratum and the workaround is costly 
performance-wise.  That piece of code would have to be checked -- I don't 
know what the order of setting of these bits would be and thus if one 
could affect the other.  The dependency would better be well documented 
then too -- my observation is the knowledge about the APIC subsystem among 
people typically only covers a narrow subset of implementations.

  Maciej
