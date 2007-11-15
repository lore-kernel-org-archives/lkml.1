Return-Path: <linux-kernel-owner+w=401wt.eu-S933026AbXKOHTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933026AbXKOHTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbXKOHRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:17:24 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:22065 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752381AbXKOHRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:17:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jPKPJqI0/rNl1n4LzzdCAbbvFGZuto11xjTtZByeHSMzHdCVWs1qc5LH5lsAQA0VvTt2D+RSsXlJ0vsxl40isYdyRnLCBzwJIletW5ZNAMMamHijMqq9SSaBvwq9jFkkaEFcpApIq0qOyVFt+n7+Lq+uk4WC5aj6sz3mPdXMzhA=  ;
X-YMail-OSG: zVj9jq0VM1nFBidPuK.Q2Qx6xdT.mBDLF6QHijQeYeYRDeygaBcYJJW5q0OC9A3_EhNg4dw7gw--
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 23:17:13 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Ingo Molnar <mingo@elte.hu>,
       Nick Piggin <nickpiggin@yahoo.com.au>
References: <200711091136.20051.david-b@pacbell.net> <200711121726.39263.david-b@pacbell.net> <alpine.LFD.0.9999.0711141228210.3265@localhost.localdomain>
In-Reply-To: <alpine.LFD.0.9999.0711141228210.3265@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711142317.14230.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007, Thomas Gleixner wrote:
> struct gpio_desc {
>        struct gpio_chip *chip;
>        int pinoffset;
> };

Eric Miao has a different notion of "gpio_desc" more analagous to
the "irq_desc", so I'll not use that name for such a structure.

Let me call yours a "struct gpio_pin" instead -- purely for some
discussion here.


There's been some desire for a "gpio_pin" struct for entirely
different reasons ... as the identifiers passed into a slightly
different type of GPIO programming interface.  So for example

  static inline void gpiopin_set_value(struct gpio_pin *p, int v)
  {
	p->chip->set(p->chip, p->pinoffset, v);
  }

One reason to be interested in gpio_chip is that it it would
easily support interoperation between traditional GPIO ID schemes
(numbered to match the SOC at the heart of a given board) and
more dynamic ones that might be needed to use curiousities like
a set of USB-to-GPIO adapters.

- Dave
