Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466AbYJPQfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466AbYJPQfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYJPQf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:35:26 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:6909 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751132AbYJPQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:35:25 -0400
Date: Thu, 16 Oct 2008 20:35:23 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: fix oops on reading sysfs exported GPIOs
Message-ID: <20081016163523.GA27938@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016144503.GA17455@oksana.dev.rtsoft.ru> <200810160843.08553.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200810160843.08553.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:43:08AM -0700, David Brownell wrote:
[...]
> > GPIO users should always issue the gpio_direction_input() call and
> > check its return value prior to trying gpio_get_value().
> 
> Not true; the API explicitly allows GPIOs to be treated
> as bidirectional, even when they're configured as outputs.
> That's because most GPIOs *are* bidirectional.

I just recalling somebody was speaking about not wasting cycles with
the checks in the gpio_{set,get}_value(). And the solution was that
before using the gpio_{set,get} one should always try to issue the
"direction" calls to ensure that gpio controller is capable of that
direction... That way gpio_{set,get}_value() don't have to check
anything.

Though I can't find the discussion now, maybe it was a dream... :-)


Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
