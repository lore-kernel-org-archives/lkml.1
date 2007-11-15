Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXKOIRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXKOIRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:17:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbXKOIRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:17:33 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:28056 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751411AbXKOIRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:17:33 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=LCQod7xlCydN8vev13pg5FHZRG+/KCk6mXazEl5BT3AYJJF8Ze4frzAvC636/NftSusGjzz+jWe2795aw/oCpgNwCoYMorn5XDd285k5FkczhhbfDG2ED6rhBep7720GtPf1BTLNMPZpC9+1zjU4FKDbAIbkcLQFX8FJYFUO2oA=  ;
X-YMail-OSG: TyJXgkMVM1nMKAoQ3rNTdMxDBNlvME5ANyU3HDc4c0hxlUvWV7j1e5vnLQX0WoYhn8Hl5Jtn0Q--
From: David Brownell <david-b@pacbell.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Thu, 15 Nov 2007 00:17:29 -0800
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711142228.10934.david-b@pacbell.net> <200711150551.54230.nickpiggin@yahoo.com.au>
In-Reply-To: <200711150551.54230.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711150017.29617.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007, Nick Piggin wrote:
> > > > All this does is prevent constant and needless checking for
> > > > "do you want to preempt me now?" "now?" "now?" in "now?" the
> > > > middle "now?" of "now?" i/o "now?" loops.
> > >
> > > Actually that's wrong.
> >
> > Certainly it's right for the mainstream kernel.  Dropping a
> > lock (other than a raw spinlock) does that checking; when a
> > loop needs to acquire then drop such a lock, that's exactly
> > what's going on.
> 
> Obviously a raw spinlock is no different from a regular
> spinlock upstream.

Erm, no.  The raw ones don't have the extra logic when
the lock gets dropped.

