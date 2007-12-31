Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbXLaCcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbXLaCcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 21:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXLaCco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 21:32:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34803 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbXLaCco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 21:32:44 -0500
Date: Mon, 31 Dec 2007 03:34:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Eduard-Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Andi Kleen <andi@firstfloor.org>, pharon@gmail.com,
       Rene Herman <rene.herman@keyaccess.nl>,
       "David P. Reed" <dpreed@reed.com>,
       Richard Harman <richard@richardharman.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
       tglx@linutronix.de
Subject: Re: [PATCH] Option to disable AMD C1E (allows dynticks to work)
Message-ID: <20071231023423.GA6530@one.firstfloor.org>
References: <47765D11.2040903@reed.com> <1198967334.5049.3.camel@iamer-laptop> <4776F6A0.9010801@keyaccess.nl> <1198979361.11150.2.camel@iamer-laptop> <20071230121725.11d05099@linux360.ro> <p73ejd41bxy.fsf@bingen.suse.de> <20071230231208.0c766258@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071230231208.0c766258@linux360.ro>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As far as I can see, the kernel doesn't behave as it would be, IMO,
> normal. I do have HPETs and Linux detects them without any
> need for hpet=force (HPET is registered for clockevents), but keeps
> LAPIC as the only option for dynticks. It looks like timing devices are
> rated and then only one of them is selected for dynticks. But when that

LAPIC is preferred because it is cheaper to reprogram, but if LAPIC
doesn't work (e.g. due to AMD C1E) it should fall back to HPET.

> Linux does not fallback to the next best timer, as dynticks is provided
> with only one such device, hence the message "lapic is not functional"
> is shown. In fact, this selection process should be fixed.

Yes it should. Something must be indeed wrong.

> approach wasn't correct, but please tell me: is HPET-driven dynticks
> code working? (I'm quite confused, as HPET should wake the CPUs even

AFAIK it should work, but I haven't tested it myself. Thomas G.
should know details.

> With my patch (the one that disables C1E), powertop shows at most 10-11
> wakeups per second when idle (no X server running). Isn't it
> reasonable to expect a significant improvement over HZ=100?

Did you measure the actual power? Minimal wakeups is not the ultimate goal,
the ultimate goal is to save power. Minimal wakeups is just a measure to that


-Andi
> 
