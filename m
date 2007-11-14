Return-Path: <linux-kernel-owner+w=401wt.eu-S1759274AbXKOI0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759274AbXKOI0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbXKOI0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:26:00 -0500
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:40197 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754785AbXKOI0A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:26:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Pp1PJLynRMWZtcLFbi0vXWSdEHMWghBWbvkJ6WE/HhxoHE4CvOSPBbuI7EFCIWhbvAnpZhBjdxNQwuoXIMfd1QWiv0dXF6s8iiaIbsNhrO4TNOhe686Hu77r2NegIkyEnyFhZYzWjR/XwchQC4gFdqyWZHxnX27ud+1nSGMjv9A=  ;
X-YMail-OSG: vC389AkVM1mf0irX8R5U6_.Yzfjbnalriv.1zK2XNgs8TpS7lfyh.7pwIRb6VI8PpuGuLQOBvQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Thu, 15 Nov 2007 06:19:27 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711150551.54230.nickpiggin@yahoo.com.au> <200711150017.29617.david-b@pacbell.net>
In-Reply-To: <200711150017.29617.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711150619.27571.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 19:17, David Brownell wrote:
> On Wednesday 14 November 2007, Nick Piggin wrote:
> > > > > All this does is prevent constant and needless checking for
> > > > > "do you want to preempt me now?" "now?" "now?" in "now?" the
> > > > > middle "now?" of "now?" i/o "now?" loops.
> > > >
> > > > Actually that's wrong.
> > >
> > > Certainly it's right for the mainstream kernel.  Dropping a
> > > lock (other than a raw spinlock) does that checking; when a
> > > loop needs to acquire then drop such a lock, that's exactly
> > > what's going on.
> >
> > Obviously a raw spinlock is no different from a regular
> > spinlock upstream.
>
> Erm, no.  The raw ones don't have the extra logic when
> the lock gets dropped.

If you don't have preemption disabled already, then it is a
bug to use raw spinlocks. If you do have preemption disabled,
then a regular spinlock isn't going to check preemption after
the unlock either.
