Return-Path: <linux-kernel-owner+w=401wt.eu-S1756248AbYGVD4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248AbYGVD4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGVD4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:56:38 -0400
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:29058 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751577AbYGVD4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:56:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uBHjcCp+e0Mtnmq8wBi8LQBPutrdiHbOwYcJaI0zjHGePTqqcoOK+BTKzriJq/R/qnEJTgS/8pQm8DZs2rcS7vBjVH8aq2iMrXFQKBtR7gQ7XTwisaRwu4WOSeMp6TemCK4fnEv2zsBt8JRydJRt1GPDEE8VpbFGym2e5cRUyxE=  ;
X-YMail-OSG: fjgZbU4VM1ligkkNNlC9fme9LrWN0cI.6ZzqKNFjZ6Gjzgg6L4wMKdm8WiqIBh.pMxwOK4xrg2.Dpuk8CzHOp0ZB6znT9dNqe71MxkOTvBUM7AC7Bh5R5BFZawKWgabrB0A-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC] schedule_timeout_range()
Date: Tue, 22 Jul 2008 13:56:29 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, arjan@infradead.org
References: <1216695757.18980.16.camel@shinybook.infradead.org> <1216695942.18980.19.camel@shinybook.infradead.org>
In-Reply-To: <1216695942.18980.19.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221356.29892.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 July 2008 13:05, David Woodhouse wrote:
> Along the same lines as the previous patch, this provides
> schedule_timeout_range() for when the precise moment of wakeup doesn't
> matter (and isn't worth wasting power on), but any time the CPU happens
> to be awake within a given range of time is fine.
>
> Implement schedule_timeout() using it, and likewise for the _killable,
> _interruptible and _uninterruptible variants.

Rather than specific "deadline" values (which we can't guarantee anyway),
or vague "can defer" values, I would prefer just a small selection of
maybe orders of magnitude flags, maybe SECONDS, MILLISECONDS, MICROSECONDS
which gives an amount of delay the kernel might add to the timer.

If you prefer the deadline parameter, don't call it a hard deadline
which is misleading.

Otherwise, seems like a pretty good idea.
