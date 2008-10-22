Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYJVBD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYJVBD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 21:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbYJVBDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 21:03:50 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:29303 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751771AbYJVBDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 21:03:50 -0400
Date: Wed, 22 Oct 2008 05:03:47 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081022010347.GA7377@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810171324.42650.david-b@pacbell.net> <20081017212942.GA1919@oksana.dev.rtsoft.ru> <200810200029.58312.david-b@pacbell.net> <20081020154835.GA3234@oksana.dev.rtsoft.ru> <1224635360.7654.294.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <1224635360.7654.294.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 11:29:20AM +1100, Benjamin Herrenschmidt wrote:
> 
> > But it doesn't work as a module (i.e. OF-specific bits should be
> > always in-kernel).
> 
> Why not ?

If say "X" driver loads prior to bus-notifier module (where we fill
the platform data), then X.0 device will try to probe w/o platform
data and will fail. The only way to re-probe things is to rmmod X &&
insmod of_pdata_filler_X && insmod X. So things depend on the module
load order.

The obvious solution is to link the OF stuff into the module, but
this also won't work, since modules have only one entry (and exit)
point. So there is no way* to hook our OF helpers into the module.

* Well, there is one solution to this problem. We can implement
arch-specific init_module and cleanup_module entry/exit points,
where we can load/unload the OF hooks. This is quite easy, but
may look ugly. I could show the drafts.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
