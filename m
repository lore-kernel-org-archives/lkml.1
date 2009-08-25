Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbZHYTbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbZHYTbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756095AbZHYTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:31:51 -0400
Received: from claw.goop.org ([74.207.240.146]:59229 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782AbZHYTbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:31:50 -0400
Message-ID: <4A943C28.2040104@goop.org>
Date: Tue, 25 Aug 2009 12:31:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Ingo Molnar <mingo@elte.hu>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
References: <4A9407B1.6020400@nets.rwth-aachen.de>	 <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>	 <4A94161A.2020609@nets.rwth-aachen.de>	 <1251219129.4852.1.camel@penberg-laptop>	 <4A94242E.30309@nets.rwth-aachen.de>	 <1251223399.13451.5.camel@penberg-laptop>	 <4A942BDD.70303@nets.rwth-aachen.de> <20090825182510.GA6903@elte.hu>	 <4A942DB9.3020209@goop.org>  <4A942F96.7000900@nets.rwth-aachen.de> <1251225834.13451.13.camel@penberg-laptop>
In-Reply-To: <1251225834.13451.13.camel@penberg-laptop>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/09 11:43, Pekka Enberg wrote:
> Aha, the previous patch worked because I #ifdef the WP test completely.
> Jeremy, the root cause here is that we do the WP test much earlier than
> before. Even with the test moved to trap_init(), we do it early compared
> to what we did before.
>
> I guess Xen is not prepared to handle traps this early in the boot
> sequence? Can we fix that?
>   

The crash is in the event (interrupt) path, which shouldn't be involved
in trap handling at all.  I'm wondering if interrupts are getting
enabled as a side-effect of handling the trap.

    J
