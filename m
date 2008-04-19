Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbYDSDqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbYDSDqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbYDSDqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:46:05 -0400
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:32077 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754564AbYDSDqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:46:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MhBU6YnXpkbUCxo4rayAh2bdgL+1mYeui2jy+NiWrk9bljQq2ucxlPgDbF8lmoTdD571Mxc1jtP8cHWmR/uElwD9zGhcdru0QMYGt2DQr/7zsq5Qo0poq7jpZCSmNv9urQFJf/zJuEQT0uJl3KTl8D+doLMdqKYhHYnorQKacc0=  ;
X-YMail-OSG: UWuaBhMVM1kZ7RfUuMZqA.KN2Dc.om_ktfalP2cfUa1mwFAOG5pYxdCOGiRXa9GZjpYcUNIIo5HvUE0kB0.38rigu053cGo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] Higer latency with dynamic tick (need for an io-ondemand govenor?)
Date: Fri, 18 Apr 2008 20:45:56 -0700
User-Agent: KMail/1.9.6
Cc: "Woodruff, Richard" <r-woodruff2@ti.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com> <1179474567.12981.53.camel@chaos> <3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com>
In-Reply-To: <3B6D69C3A9EBCA4BA5DA60D91302742904131BED@dlee13.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804182045.56893.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 April 2008, Woodruff, Richard wrote:
> When capturing some traces with dynamic tick we were noticing the
> interrupt latency seems to go up a good amount. If you look at the trace
> the gpio IRQ is now offset a good amount.  Good news I guess is its
> pretty predictable.

That is, about 24 usec on this CPU ... an ARM v7, which I'm guessing
is an OMAP34xx running fairly fast (order of 4x faster than most ARMs).

Similar issues were noted, also using ETM trace, on an ARM920 core [1]
from Atmel.  There, the overhead of NO_HZ was observed to be more like
150 usec of per-IRQ overhead, which is enough to make NO_HZ non-viable
in some configurations.


> I was wondering what thoughts of optimizing this might be.

Cutting down the math implied by jiffies updates might help.
The 64 bit math for ktime structs isn't cheap; purely by eyeball,
that was almost 1/3 the cost of that 24 usec (mostly __do_div64).

- Dave

[1] http://marc.info/?l=linux-kernel&m=120471594714499&w=2

