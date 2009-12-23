Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZLWOWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZLWOWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 09:22:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbZLWOWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 09:22:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33141 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036AbZLWOWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 09:22:05 -0500
Date: Wed, 23 Dec 2009 14:20:12 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>, awalls@radix.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: workqueue thing
Message-ID: <20091223142011.GD4799@sirena.org.uk>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, awalls@radix.net,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	jens.axboe@oracle.com, rusty@rustcorp.com.au,
	cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
	avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
References: <4B2F7879.2080901@kernel.org> <1261405604.4314.154.camel@laptop> <4B3009DC.7020407@kernel.org> <1261480001.4937.21.camel@laptop> <4B319A20.9010305@kernel.org> <alpine.LFD.2.00.0912222032360.6879@localhost.localdomain> <20091223060229.GA14805@elte.hu> <4B31B508.5040903@garzik.org> <1261557674.4937.117.camel@laptop> <4B31F028.7060209@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B31F028.7060209@garzik.org>
X-Cookie: Double!
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 05:25:44AM -0500, Jeff Garzik wrote:
> On 12/23/2009 03:41 AM, Peter Zijlstra wrote:

>> So why are threaded interrupts not considered? Isn't the typical atomic
>> context of drivers the IRQ handler?

> I don't see a whole lot of driver authors rushing to support threaded  
> interrupts.  It is questionable whether the myriad crazy IDE interrupt  

Threaded interrupts are fairly new and there's not an enormous win from
converting existing drivers at present, it's more likely that new code
will use them at the minute.

> routing schemes are even compatible.  Thomas's Mar 23 2009 email says  
> "the primary handler must disable the interrupt at the device level"  
> That is not an easy request for all the hardware libata must support.

That requirement is no longer there since it was making threaded
interrupts useless for devices controlled over interrupt driven buses,
which are one of the major use cases for threaded IRQs.

None of which should be taken as a comment on the proposal under
discusssion.
