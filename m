Return-Path: <linux-kernel-owner+w=401wt.eu-S1761178AbYGVFt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761178AbYGVFt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbYGVFf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:35:56 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54530 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759453AbYGVFfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:35:55 -0400
Date: Tue, 22 Jul 2008 07:35:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: David Woodhouse <dwmw2@infradead.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       arjan@infradead.org
Subject: Re: [RFC] schedule_timeout_range()
In-Reply-To: <1216702732.18980.83.camel@shinybook.infradead.org>
Message-ID: <alpine.LNX.1.10.0807220729560.23410@fbirervta.pbzchgretzou.qr>
References: <1216695757.18980.16.camel@shinybook.infradead.org>  <200807221433.32412.nickpiggin@yahoo.com.au>  <1216701925.18980.75.camel@shinybook.infradead.org>  <200807221450.10146.nickpiggin@yahoo.com.au>
 <1216702732.18980.83.camel@shinybook.infradead.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-07-22 06:58, David Woodhouse wrote:
>
>> > In practice, they'll almost always get called before that maximum time
>> > expires -- that's the whole _point_, of course. But we can't _invent_
>> > that maximum in generic code; that's really up to the caller.
>> 
>> Not a maximum, but just an "I don't know... a lot?" define. But yeah
>> I guess there aren't too many good reasons for that.
>
>I'd really like to avoid it. It puts the responsibility for coming up
>with a number a _long_ way from where it should be, in the individual
>caller.

Wait for drivers to make use of the range timer, hear their requirements
out, then can make a better-informed decision about the preciseness
of "a lot[?]". Maybe it turns out that drivers only ever need a range
like r={20msec, Infinity} because, say, a drive's status just remains
available anytime after 20msec until (finally) polled.
