Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbYJVEUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbYJVEUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbYJVEUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:20:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:21220 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYJVEUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:20:25 -0400
Date: Tue, 21 Oct 2008 22:20:22 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: avorontsov@ru.mvista.com, David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081022042022.GB7176@secretlab.ca>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810171324.42650.david-b@pacbell.net> <20081017212942.GA1919@oksana.dev.rtsoft.ru> <200810200029.58312.david-b@pacbell.net> <20081020154835.GA3234@oksana.dev.rtsoft.ru> <1224635360.7654.294.camel@pasglop> <20081022010347.GA7377@oksana.dev.rtsoft.ru> <20081022014243.GA19362@oksana.dev.rtsoft.ru> <1224642497.7654.319.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224642497.7654.319.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 01:28:17PM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2008-10-22 at 05:42 +0400, Anton Vorontsov wrote:
> > 
> > Thinking about it more, I started recalling other issues. The bus
> > notifier chain doesn't replay previous events, so we also have to
> > register the notifier before the _devices_ are registered. And this
> > ruins the whole approach. :-/ Yeah, that's why I abandoned the bus
> > notifier idea.
> 
> The notifier can be registered before the devices, though it's a little
> bit fishy and fragile.
> 
> Easier I suppose to just have OF specific hooks in the bus code.

Every time I think about the problem, this is the conclusion that I come
to.  Either have OF specific hooks in the probe/remove functions; or
have separate probe/remove for OF created instances of a device.

g.
