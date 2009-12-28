Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZL1Keg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZL1Keg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 05:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZL1Kef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 05:34:35 -0500
Received: from crmm.lgl.lu ([158.64.72.228]:43462 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbZL1Kef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 05:34:35 -0500
Message-ID: <4B38882C.7060903@knaff.lu>
Date: Mon, 28 Dec 2009 11:27:56 +0100
From: Alain Knaff <alain@knaff.lu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mark Hounschell <markh@compro.net>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "dmarkh@cfl.rr.com" <dmarkh@cfl.rr.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "fdutils@fdutils.linux.lu" <fdutils@fdutils.linux.lu>,
       "Li, Shaohua" <shaohua.li@intel.com>, Ingo Molnar <mingo@elte.hu>,
       morgan@physics.ucla.edu
Subject: Re: [Fdutils] DMA cache consistency bug introduced in 2.6.28
References: <4B32386B.2060509@compro.net> <alpine.LFD.2.00.0912230828230.6879@localhost.localdomain> <87bphpd4rt.fsf@basil.nowhere.org> <alpine.LFD.2.00.0912230845550.6879@localhost.localdomain> <20091223170832.GH20539@basil.fritz.box> <20091225132116.6c9089f2@infradead.org> <20091225203304.GA22306@basil.fritz.box> <20091226103835.68479100@infradead.org> <20091226164029.GA10256@basil.fritz.box> <4B3752F5.3080205@knaff.lu> <20091228015446.GA3012@basil.fritz.box>
In-Reply-To: <20091228015446.GA3012@basil.fritz.box>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> disable_hlt/enable_hlt was only needed to work around a bug on TM4000
>> (Texas Instrument) Laptops which were popular around 1994 / 1995.
> 
> I don't think we can fully drop support for these systems.
> 
> Did they have an unique PCI ID or something else that could be tested
> for?

Floppy controllers are not PCI devices and thus have no PCI id
unfortunately... :-(

> Perhaps it could be just a white list like dmi_year > 1995 to disable.
> 
> Depending on how often floppies are still used this might save
> non trivial amounts of power on newer systems :)

Removing these calls will indeed save a *tiny* amount of power by
allowing the CPU to go into halt during DMA transfer. But the main
argument should be simplification.

> Anyways it would be probably good to convert this to the new infrastructure,
> and remove the old hooks, but the interrupt-context issue would
> need to be fixed first.
> 
> -Andi

Well, at least for testing whether it fixes the new problem (DMA cache
issue), it's useful to know that these calls can be safely removed on
almost all of today's machines. That way, we will know whether this
refactoring will be worth the effort.

Regards,

Alain
