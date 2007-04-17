Return-Path: <linux-kernel-owner+w=401wt.eu-S1030819AbXDQSqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819AbXDQSqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 14:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031131AbXDQSqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 14:46:24 -0400
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:40205 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1031120AbXDQSqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 14:46:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tRib6UT1QFUIkewU26qYwvwMh4OKJSIgX0mG+mrIsviTo5L+MCFhf0ywt4K1sXI0c9j2/FuMLuynjdIrJ3rUI6zNV+TUk0/e9DJcd7H2sN3sO9iCRlLD6RUVIlKY1LzW2BC+g+UnY9qSse5TSj6TXixEh+6UbbcRXXHzqBHf+Ao=  ;
X-YMail-OSG: XOgD.k4VM1lFDUgk0R3PnW.rjPUf7PX17i0bQA2pUFhWYB54UHBrolzQwEb2S4lTX5p3EP_veA--
From: David Brownell <david-b@pacbell.net>
To: "Francis Moreau" <francis.moro@gmail.com>
Subject: Re: question on generic gpio interface
Date: Tue, 17 Apr 2007 09:42:49 -0700
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org
References: <38b2ab8a0704131351la5085vf0ab58e85cf49879@mail.gmail.com> <200704160646.59407.david-b@pacbell.net> <38b2ab8a0704170004h12c4ea41we6bdab3a1b443a18@mail.gmail.com>
In-Reply-To: <38b2ab8a0704170004h12c4ea41we6bdab3a1b443a18@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704170942.49626.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2007 12:04 am, Francis Moreau wrote:

> BTW, are there any plan to make gpio usable from userspace ? I don't
> know if it makes sense but I saw some patches on LKML that did that.

Only the usual plan:  someone who wants that feature provides a driver,
which can be merged after suitable review.

For example, the gpio_keys and leds-gpio drivers already exist to
expose some kinds of GPIOs ... though not specifically as GPIOs.
And I've seen various drivers that package GPIOs on specific chips,
mostly for _exclusive_ use by userspace (no kernel access).


In this case I'm not entirely sure how it'd work.  I've seen a few
drivers which let userspace peek and poke at GPIO signals -- like
one for Gumstix boards -- but generalizing the model isn't simple.
Sub-problems include:

 - Configuring the relevant pins.  Especially for SOC cases, GPIO
   roles are multiplexed with several others.  So there are two
   issues:  (a) the platform-specific setup of that multiplexing,
   plus (b) the board-specific knowledge of what pins are truly
   available for use as GPIOs, and not otherwise in use.

 - Enumerating those GPIOs to userspace.  One SOC might have just
   a few dozen, another might have a few hundred; and then there
   are all the board-specific ones, on FPGA or I2C chips etc.

 - Exposing those pins to userspace.  It'd be unsafe to let pins
   claimed by drivers be managed by userspace; the default should
   be that only unclaimed GPIOs can be accessed.

Those points imply part of a design that includes board-specific
hooks of various kinds (maybe delegating a lot to platform code).

But nobody's yet provided code that would generalize.

- Dave
