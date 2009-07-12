Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZGLJas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZGLJas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 05:30:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbZGLJak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 05:30:40 -0400
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:46099 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751315AbZGLJak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 05:30:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Rjjoy3t0h6k70I6Yv/13V6n6Kakfb8tFQYJLFMYVwXZnHAYhyZg4yPCUAjTq1qirD9BI6Rbqd9f+S9CjRPY+bnK6y8U94CEl8GrMIwF4DJeW8XFGPgNZnFHH0EISctNgCQcIlUFhWe0mqqTJZ5POggJclT7XIZZENhXW4vnsDiI=  ;
X-YMail-OSG: iQxU6GsVM1mKO8ks1Q18YWUR2WEcCbCfnFFcac0p8dD2DbyJ666TxvKj3DKsCFFxRhcOdkeaNDdpnTwoCnYkQhZtLRo.R1FhnIfzgIzLM4S_.7mobsczQxJUqAgzLUD5mmcr6ajDgI8j0pX5YT8zSZYcKhTTr4x9gRVXLkWQm8nCamda3pWC1kzi8vHygzhxWUen8UBJUuhf_L8p7.Rd0swFIKOPmOnvO9gnLr58qFlq7u3wx27jJWDzeNTBOkhdVKEWpYNEdO8D3XusP2alAw0s.K3u6QOg7WKk90htbQvIcILT8Y.9
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] move omap_udc's probe function to .devinit.text
Date: Sun, 12 Jul 2009 02:30:37 -0700
User-Agent: KMail/1.9.10
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <20090711170548.GC5205@suse.de> <20090712083510.GA24424@pengutronix.de> <20090712084734.GA944@flint.arm.linux.org.uk>
In-Reply-To: <20090712084734.GA944@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907120230.38293.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 July 2009, Russell King wrote:
> Your approach is perfectly fine, and safe.  You're not adding any
> additional bloat which isn't already there.

He is most certainly increasing the runtime footprint needessly.
Runtime footprint which previously was *NOT* present.

That's known as "bloat".

And also known as "adding".


> If it were adding any 
> bloat (which it isn't), it certainly is not "in chunks of up to a
> page per patch".

Oddly, the init section of the $SUBJECT driver is about 3600 bytes.
That's what ... almost a (4K) page, wouldn't you say?

It's got a lot of one-time hardware init that was explicitly pushed
into the init section so it would stay out of the runtime image.


> Overall, this patch is an improvement, so all these get my ack, and
> they should be applied as is.

The $SUBJECT patch is most certainly NOT an improvement.

It still has a solid NAK, since it's adding almost a page of bloat.

 
> Using platform_driver_probe() does allow you to reduce the kernel
> footprint still further, but that requires knowledge of the platforms
> affected (knowing that the platform devices are present before the
> drivers get probed.)

And as I've pointed out before ... that's exactly how platform
drivers work on most platforms.  Very specifically, I've pointed
out previously to Uwe, it's how the OMAP code works.

So it's kind of perplexing to still see patches sent along which
make the situation worse.


