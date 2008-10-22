Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbYJVBmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbYJVBmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 21:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYJVBmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 21:42:45 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:29450 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751652AbYJVBmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 21:42:44 -0400
Date: Wed, 22 Oct 2008 05:42:43 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081022014243.GA19362@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810171324.42650.david-b@pacbell.net> <20081017212942.GA1919@oksana.dev.rtsoft.ru> <200810200029.58312.david-b@pacbell.net> <20081020154835.GA3234@oksana.dev.rtsoft.ru> <1224635360.7654.294.camel@pasglop> <20081022010347.GA7377@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081022010347.GA7377@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 05:03:47AM +0400, Anton Vorontsov wrote:
> On Wed, Oct 22, 2008 at 11:29:20AM +1100, Benjamin Herrenschmidt wrote:
> > 
> > > But it doesn't work as a module (i.e. OF-specific bits should be
> > > always in-kernel).
> > 
> > Why not ?
> 
> If say "X" driver loads prior to bus-notifier module (where we fill
> the platform data), then X.0 device will try to probe w/o platform
> data and will fail. The only way to re-probe things is to rmmod X &&
> insmod of_pdata_filler_X && insmod X. So things depend on the module
> load order.

Thinking about it more, I started recalling other issues. The bus
notifier chain doesn't replay previous events, so we also have to
register the notifier before the _devices_ are registered. And this
ruins the whole approach. :-/ Yeah, that's why I abandoned the bus
notifier idea.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
