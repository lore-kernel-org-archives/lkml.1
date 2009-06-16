Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbZFPGUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbZFPGUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZFPGUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:20:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZFPGUj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:20:39 -0400
Date: Tue, 16 Jun 2009 08:20:44 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Richard =?utf-8?Q?R=C3=B6jfors?= 
	<richard.rojfors.ext@mocean-labs.com>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-input@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-omap@vger.kernel.org
Subject: Re: [RESEND][PATCH] input: Added TSC2003
Message-ID: <20090616062044.GA20209@avionic-design.de>
References: <4A366439.70005@mocean-labs.com> <5d5443650906151110u3f7d9d1cm1990e767d29a45b6@mail.gmail.com> <4A36A1C2.2060805@mocean-labs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4A36A1C2.2060805@mocean-labs.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/1tL9BO5HcuB9LaaPK+aZ9L/EcMQzp0i+iAlf
 AtUeqjU8gBQmQ50JHgp6n6NqE5Ma2PjnsWtgE9i848mKv1UcVg
 eBOA1Xg7i4trCshVHBHCQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Richard Röjfors wrote:
> On 09-06-15 20.10, Trilok Soni wrote:
> > Hi,
> > 
> > On Mon, Jun 15, 2009 at 8:39 PM, Richard
> > Röjfors<richard.rojfors.ext@mocean-labs.com> wrote:
> >> Supplied is a driver for the TSC2003. There is actually a driver for TSC2007 which can be used in some cases.
> >> The platform struct is reused from the TSC2007.
> >> There is a big difference in the implementation between the drivers, this one does not use HR timers.
> >> The TSC2007 driver performs synchronous I2C in the timer callback (SW IRQ context) which is bad when
> >> the I2C driver is interrupt driven.
> >>
> > 
> > Meaning? I think I2C transaction can sleep.
> 
> Yes that's what it means, and that's bad in a HR timer callback.

Note that my patch to the tsc2007 to support the tsc2003 exactly fixes this
problem. It moves the actual I2C transfers into a workqueue, so no sleeping
functions are called from the hrtimer callback.

Thierry
