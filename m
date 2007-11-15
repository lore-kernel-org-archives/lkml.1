Return-Path: <linux-kernel-owner+w=401wt.eu-S1765639AbXKOHRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765639AbXKOHRu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbXKOHRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:17:21 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:21964 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752054AbXKOHRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:17:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1hmsl6mcTGclUtWkT14oEXxCA7YZs3nNV+hqumOcQqAxiaacI93sWs7+PwtQFpA+cCDAWMDc/J93cPpc5/exEm1QonfbV8CUxyAj0mKLojXXhJyYNKIgreI7yc9LlFQdU8OYRUwyAST5Jb2SyhlbhEVdcWA1ANqp8luU0urGuGM=  ;
X-YMail-OSG: QvoqwcUVM1nWi1_uEN0qZW_uTVmmT2eTT.6dhKtLruD.Rr_u
From: David Brownell <david-b@pacbell.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 22:23:45 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711140037.58049.david-b@pacbell.net> <200711140808.24994.nickpiggin@yahoo.com.au>
In-Reply-To: <200711140808.24994.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711142223.46061.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, Nick Piggin wrote:
> > > But these ones
> > > are raw locks rather than normal locks probably because that
> > > they are trivially an innermost and correct lock.
> >
> > As in the $SUBJECT case, I'd say.
> >
> > Although another point is related to "trivial":  the data
> > is being protected through an operation too trivial to be
> > worth paying for any of that priority logic.
> 
> A driver shouldn't get to decide that, IMO.

Not that I was talking about driver code...


> And if there is 
> some policy in the -rt tree allowing these decisions, then
> it's exactly the kind of thing we don't want upsream.

Making raw spinlocks available allows those decisions...

On the other hand, I can't see things working sanely
without them being available.  The problem seems to be
the usual one that crops up whenever anyone tries to
create a "bright line" decision algorithm in areas that
need flexibility.  Any "bright line" rule will lead to
wrong results.

- Dave

