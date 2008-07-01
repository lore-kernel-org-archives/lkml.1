Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbYGAVxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbYGAVxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 17:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbYGAVwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 17:52:55 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:17979 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760048AbYGAVwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 17:52:54 -0400
Date: Wed, 2 Jul 2008 01:52:51 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] Add support for power_supply on tosa
Message-ID: <20080701215251.GA12957@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080620084917.GA20577@doriath.ww600.siemens.net> <20080701143232.cca14c86.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080701143232.cca14c86.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 02:32:32PM -0700, Andrew Morton wrote:
> On Fri, 20 Jun 2008 12:49:17 +0400
> Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:
> 
> > Support the battery management on Sharp Zaurus SL-6000.
> > 
> > This patch depends on the tc6393xb support as found in the arm:devel
> > or linux-next trees.
> 
> Which means that Anton can't really merge it into his tree, I guess.

Hm. Actually, yesterday I applied it to battery-2.6 with assumption
that mfd part will get into mainline in 2.6.27.

Since Kconfig specify that driver depends on MFD_TC6393XB, maximum we'd
get for now is Kconfig warning wrt unknown symbol, but nothing could
select it, thus can't break the build (we have few examples of such
non-selectable drivers even in Linus' tree. For example
drivers/net/cpmac.c: there is no such thing as CONFIG_AR7 -- it is still
in openwrt tree).

But I can git --reset, should I?

[...]
> > +	mutex_lock(&bat_lock);
> > +	gpio_set_value(bat->gpio_bat, 1);
> > +	mdelay(5);
> 
> msleep() is preferred over a busywait.

I did review this patch, and did mention exactly the same, plus
some other stuff:
http://lkml.org/lkml/2008/6/23/17

Dmitry posted fixed version that I applied:
http://lkml.org/lkml/2008/6/24/266

So, in case this goes through -mm, you'd probably want the fixed version.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
