Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZFWHWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZFWHWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZFWHWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:22:38 -0400
Received: from n17.bullet.mail.mud.yahoo.com ([68.142.206.144]:31421 "HELO
	n17.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751587AbZFWHWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:22:37 -0400
X-Yahoo-Newman-Id: 536005.97018.bm@omp419.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=cWXFPgweFlMEQ4SySNfs7VY4k4u7nuiKHjt44n+onN3yrQJZQbnsL6aR/nfvUasD+h9Ix2g6iw0PFHfJuJ3JG1O3mQn6CAR4eibji+8pM+fuC3XD+wh2Dsd0VaMYeZ+IdBhDuxMR5DXwcQU/BRJIMwdxk/QxalzcjVnCi8hk85c=  ;
X-YMail-OSG: RUG8zVoVM1nh_V2hMOCiJtKvUJT5M_HyVfw7YgQXuCyMmmZca5ABWupJzMZDZo8jmU1rlSG8jwC5QPsTG2Uz0E0rwgle7yHBnO9aGdRVRFdo1PRv7Ys2QUCM60B68VL1MWpfLY75a_4W1oEtgj.3EF4LtlWIQ1mprrTBV31XtwyYC6BBgdaZtyTo9IYKhcb9yEuxQOcObAMKsFL37wvL_GMQmYcQ2fmdCtEXcV6QPHjrmS2kczh28uolHpRGbFY3IaIjvtVoj5nylruv5eVLVYA5hQVUZC_0R_q3OVqRumjlpFaZbnih
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: PROBLEM: kernel oops with g_serial USB gadget on 2.6.30
Date: Tue, 23 Jun 2009 00:22:38 -0700
User-Agent: KMail/1.9.10
Cc: "'Alan Stern'" <stern@rowland.harvard.edu>,
       "'Peter Korsgaard'" <jacmet@sunsite.dk>,
       "'USB list'" <linux-usb@vger.kernel.org>,
       "'Kernel development list'" <linux-kernel@vger.kernel.org>,
       kyungmin.park@samsung.com
References: <001201c9f341$20b8b710$622a2530$%szyprowski@samsung.com> <200906222026.51511.david-b@pacbell.net> <001c01c9f3cd$ad02b1d0$07081570$%szyprowski@samsung.com>
In-Reply-To: <001c01c9f3cd$ad02b1d0$07081570$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200906230022.39040.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 June 2009, Marek Szyprowski wrote:
> 
> > Like, oh, changing a spinlock to a mutex.   You might change the
> > low_latency setting and review how that's now supposed to behave.
> 
> In in gs_open() function in drivers/usb/gadget/u_serial.c, after the 
> line 780 I've added:
> 
> tty->low_latency = 1;

That's already how it's set.  Try instead *REMOVING* the line
which sets that flag.


> This helped a bit, but after a few serial transfers I got the same 
> bug again.

Of course.  You didn't change anything.


