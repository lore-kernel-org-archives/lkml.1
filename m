Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYIEMBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYIEMBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYIEMBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:01:34 -0400
Received: from r00tworld.com ([212.85.137.21]:60112 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYIEMBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:01:33 -0400
From: pageexec@freemail.hu
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>
Date: Fri, 05 Sep 2008 14:00:38 +0200
MIME-Version: 1.0
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Reply-to: pageexec@freemail.hu
CC: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, tglx@tglx.de, hpa@zytor.com
Message-ID: <48C11F66.18988.341780A@pageexec.freemail.hu>
In-reply-to: <20080905114233.GA27878@elte.hu>
References: <20080903195122.73905236@infradead.org>, <1220612231.4879.175.camel@pasglop>, <20080905114233.GA27878@elte.hu>
X-mailer: Pegasus Mail for Windows (4.50 PB1)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.21]); Fri, 05 Sep 2008 14:01:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 Sep 2008 at 13:42, Ingo Molnar wrote:
> The other, more fundamental problem that nobody has mentioned so far is 
> that the check returns -ENOSYS and thus makes rootkit attacks _more 
> robust_ and hence more likely!
> 
> The far better solution would be to insert uncertainty into the picture: 
> some sort of low-frequency watchdog [runs once a second or so] that 
> tries to hide itself from the general kernel scope as much as possible, 
> perhaps as ELF-PIC code at some randomized location, triggered by some 
> frequently used and opaque kernel facility that an attacker can not 
> afford to block or fully filter, and which would just check integrity 
> periodically and with little cost.

there's that adage about history being repeated by those not knowing it ;)
for details see the series based around bypassing Vista's PatchGuard at:

  http://uninformed.org/?v=3
  http://uninformed.org/?v=6
  http://uninformed.org/?v=8

> A good benchmark for such a silent alarm facility would be whether an 
> experienced kernel developer could reliably tell it via a kgdb session 
> and full access to memory and system symbols that such a silent alarm is 
> running on a box. If he cannot do it reliably then there's probably no 
> good way for an attacker either.

i believe the above mentioned papers prove that it's not a good benchmark ;)

