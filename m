Return-Path: <linux-kernel-owner+w=401wt.eu-S1753465AbXDLUrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbXDLUrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 16:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbXDLUrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 16:47:33 -0400
Received: from mx2-2.mail.ru ([194.67.23.122]:15213 "EHLO mx2.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753465AbXDLUrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 16:47:32 -0400
Date: Fri, 13 Apr 2007 00:44:13 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Paul Sokolovsky <pmiscml@gmail.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, Shem Multinymous <multinymous@gmail.com>
Subject: Re: [Kernel-discuss] Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070412204413.GA3151@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070412130817.GA29900@srcf.ucam.org> <20070412141505.GA25552@zarina> <20070412142430.GA31240@srcf.ucam.org> <1734853889.20070412173626@gmail.com> <20070412185630.GC27804@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070412185630.GC27804@khazad-dum.debian.net>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:56:30PM -0300, Henrique de Moraes Holschuh wrote:
> On Thu, 12 Apr 2007, Paul Sokolovsky wrote:
> >   Yes, that's apparently the way to go. We just should consider
> > if mAh and mWh are enough, or we go wider and allow whole collection of
> > units. Btw, original handhelds.org code used Joules ;-).
> 
> FWIW, SBS only mentions mAh and mWh.  AFAIK, all other (meaningful) units
> should be able to be converted to either Ah or Wh, assuming enough precision
> on the math.  I never heard of any other way to fuel-gauge batteries than
> these two main modes (current-based or capacity-based), but I don't work on
> the battery field.

Okay, I have an idea:

Let's name attributes with mWh units as {min_,max_,design_,}energy,
and attributes with mAh units as {min_,max_,design_,}charge.

Because both energy and charge represents ""capacity"" in some meanings,
and that's why we bothering with _units attribute. So, lets drop
"capacity"* and use more specific terms? I really don't want string
attributes by default (except status).

If we export attributes with predefined units, userspace developers
could just look into include/linux/battery.h and conclude: "Ah, great,
if battery reporting energy, then it's in mWh, and if battery reporting
charge it's always in mAh".

* Yup, I've read last discussion regarding batteries, and I've seen
  objections against "charge" term, quoting Shem Multinymous:

  "And, for the reasons I explained earlier, I strongly suggest not using
  the term "charge" except when referring to the action of charging.
  Hence:
  s/charge_rate/rate/;  s/charge/capacity/"

  But lets think about it once again? We'll make things much cleaner
  if we'll drop "capacity" at all.

> That said, you may need to use uWh and uAh instead of mAh and mWh, though.

Not sure. Is there any existing chip that can report uAh/uWh? That is
great precision.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
