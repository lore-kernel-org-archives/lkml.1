Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358Ab0B0RvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:51:12 -0500
Received: from smtp104.sbc.mail.gq1.yahoo.com ([67.195.15.63]:21684 "HELO
	smtp104.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030276Ab0B0RvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:51:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZJyogkRcjYucLa8Rtvpvg3WQonaR9Uoto55m+RvuO6HhqScP1/ijbyIP4hUaZK1NXqs8PP1wCEmAQ7QQ/IZzXMZbJe094yzNJ4EQ2+q9ojNax5d2Pl2pncAmAOmCpVceujNNeR+T8TgkeYbapTWiRGphNwnpxDB0WuDF1Ejq/AM=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: AN59rR0VM1kcSUmYGEr1HNJnJyvZ_dgnAWBMBaDOlnj053pr868KwRUNVUFwOZ0Alhj0yMMUy_uoEotWP5TiLSnserHQJZMvSLc3bNwFd0Fe_MXBQV6OwMmr46X4BtFg__dcugqYdBCz4EU25UQboahAJ_kXyUtozUAvvvgav6UPobgJLuY5f644vq_sRi3YHg5w5nKOON34_U.5dnO5n74oK_qjjqq03mgke0Uw2RcAyQr6HC19VKTywm9KQxk.JxlfHm1aPFzxO7vxm_Qh.On5rJ2p_pHvjWfK7J4RRRi15j7nHleA8Oc-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
Date: Sat, 27 Feb 2010 09:51:08 -0800
User-Agent: KMail/1.9.10
Cc: Ben Gardner <gardner.ben@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <cover.1267225701.git.gardner.ben@gmail.com> <201002270824.14889.david-b@pacbell.net> <A6EC110C-1712-4AC7-B828-D7BB08278996@opensource.wolfsonmicro.com>
In-Reply-To: <A6EC110C-1712-4AC7-B828-D7BB08278996@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <201002270951.09045.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 February 2010, Mark Brown wrote:
> >>>  "none" ... since it's not even a GPIO, why would it show
> >>>       up through the GPIO subsystem???
> >>
> >> I suspect this is intended to be tristated, which might be useful  
> >> to add.
> >
> > That's what "input" means, as a rule:  no output driver
> > is active with a GPIO configured as "input".  "Tristate"
> > is an option that's relevant for outputs ... low, high,
> > or not-driven.
> 
> Indeed, but some devices do implement a distinct tristate state for  
> input mode pins (disabling interrupt generation logic and so on for  
> example).

That's a pretty sloppy usage of the term "tristate" ... yeah, there
are people who take glee in abusing terminology to introduce confusion,
and some of them write technical manuals with little regard to normal
usage of terms (or trademarks, which do exist for "tristate").

IRQ generation logic should be disabled until request_irq() code paths
report otherwise.   And regardless, whether a GPIO triggers an IRQ has
nothing at all to do with its "direction".

- Dave

