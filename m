Return-Path: <linux-kernel-owner+w=401wt.eu-S1751935AbYGXAye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935AbYGXAye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbYGXAyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:54:01 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:40957 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750894AbYGXAx7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:53:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=lf9uaerpeaGYQkr7Le/t+f490fS+ZjZxRUe4B8GPiWAvcdQvwI9R9Sr77ca0J0PZfqx07uqsV5dZC0MNhXpDimBqRYW0pxaqY4hgymnij7JR5apQv5SsGQodRCzq1IuHljaQA46EgNEICWRFgSEg81iqdr+fVm/KZQNzniQtXvY=  ;
X-YMail-OSG: GXh7Pn4VM1kRWABzz6H66Y5PHCG7VpskxOHBp7OLz3Bkijd_44S5rhRvWRXXcW7b6zolPFIX0PZmMFX9TdfDCMQMm1O379a4tf0vR39mCcdcC6JANSuW020d7YH1m31wTWg-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: 7eggert@gmx.de
Subject: Re: [RFC] schedule_timeout_range()
Date: Thu, 24 Jul 2008 10:53:49 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org,
       David Woodhouse <dwmw2@infradead.org>
References: <aSgqr-EJ-15@gated-at.bofh.it> <aShPs-4IY-1@gated-at.bofh.it> <E1KLct4-0001Wx-O9@be1.7eggert.dyndns.org>
In-Reply-To: <E1KLct4-0001Wx-O9@be1.7eggert.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807241053.49304.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 July 2008 21:52, Bodo Eggert wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > The only thing I dislike about explicit times is that when a driver or
> > someone doesn't _really_ know how much to specify. Do you say 10s, 100s?
> > It shouldn't be arbitrary, but we should have a few constants I think.
>
> You'd replace "Should I use 10 or 100 seconds?" with "Should I use
> TIMEOUT_10_SEC or TIMEOUT_100_SEC?", while replacing "I want 40 seconds!"
> with "Danmed, I want 40 seconds, but that's not an option!".
>
> BTW: If you don't know about which timeout you should use, you should think
> about mowing the lawn instead. ¢¢

It's not always that simple. If you code drivers or network protocols,
it might seem easy, but a lot of the VM for example is riddled with
rather arbitrary heuristics. Suppose we do slab cache reaping at 1HZ
(for no really good reason)... what I want to do with that guy is to
get maximum power savings when the CPU is idle, however I don't want to
wait infinitely long because that's leaving work to do when the CPU
finally does wake up, and it also ties up memory. I want the minimum
timeout that gives maximum power saving (say, within 99.9% of theoretical
maximum).

Can you tell me how to achieve this, or do you have lawn to mow too? ;)

OK, today we probably just add a few seconds of slop and forget about it,
but actually in future if we might want to power down most of the system
between key strokes, we might want 10s of seconds of sleep time.

