Return-Path: <linux-kernel-owner+w=401wt.eu-S1764061AbYCDRKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764061AbYCDRKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156AbYCDRKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:10:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40099 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbYCDRKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:10:03 -0500
Message-ID: <47CD8161.4090901@zytor.com>
Date: Tue, 04 Mar 2008 09:05:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Mark McLoughlin <markmc@redhat.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       Andi Kleen <ak@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reserve end-of-conventional-memory to 1MB on 32-bit v2
References: <47C22568.1010405@zytor.com>   <1203958478.20033.1239002461@webmail.messagingengine.com>   <20080225170134.GA15839@elte.hu>   <20080225180750.GA31054@mailshack.com>   <20080228131341.GA25213@mailshack.com>   <1204232996.28798.8.camel@cthulhu.hellion.org.uk>   <20080229114943.GA1909@mailshack.com> <1204305247.2037.2.camel@muff>   <1204310323.24514.1239870063@webmail.messagingengine.com>   <1204322819.6299.1.camel@muff> <20080301160911.GA13271@mailshack.com>   <1204631082.16613.7.camel@muff> <47CD6858.9070603@goop.org> <1204649476.5048.1240509149@webmail.messagingengine.com>
In-Reply-To: <1204649476.5048.1240509149@webmail.messagingengine.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> If this is indeed not executed, is there a way to detect whether
> we can expect the environment to behave like a normal pc in terms
> of magic addresses, bios areas, isa reserved address space and so
> on?
> 

The subarch stuff (boot_params.hdr.hardware_subarch) is indeed executed, 
at least with newer PV guests.

However, as far as this kind of stuff, one really have to wonder to what 
extent the PV users really care about how much they perturb the guests. 
  The canonical view of virtualization is that you should perturb your 
guests as little as possible, but that doesn't really seem to be 
considered in the observable bits of the PV universe as far as I can tell.

A *massive* issue with hooks -- including paravirt_ops -- is that they 
are largely undocumented both in code and in specification, and usually 
hard-code the underlying implemenentation at a specific point in time: I 
have yet to see any sort of specification document for paravirt_ops, and 
most of the hooks are simply empty on hardware.  This means that the 
burden has shifted onto the kernel maintainers to test every possible 
paravirt_ops client, because it is quite literally the only way to know 
when it's broken.

I'm starting to feel that the PV clients need to document their 
environments and their constraints better for the benefit of the core 
maintainers.

	-hpa

