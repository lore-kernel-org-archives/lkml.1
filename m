Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYJVC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYJVC3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 22:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYJVC3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 22:29:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:52468 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYJVC3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 22:29:04 -0400
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       i2c@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
       David Miller <davem@davemloft.net>
In-Reply-To: <20081022010347.GA7377@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
	 <200810171324.42650.david-b@pacbell.net>
	 <20081017212942.GA1919@oksana.dev.rtsoft.ru>
	 <200810200029.58312.david-b@pacbell.net>
	 <20081020154835.GA3234@oksana.dev.rtsoft.ru>
	 <1224635360.7654.294.camel@pasglop>
	 <20081022010347.GA7377@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 13:27:14 +1100
Message-Id: <1224642434.7654.317.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-22 at 05:03 +0400, Anton Vorontsov wrote:
> If say "X" driver loads prior to bus-notifier module (where we fill
> the platform data), then X.0 device will try to probe w/o platform
> data and will fail. The only way to re-probe things is to rmmod X &&
> insmod of_pdata_filler_X && insmod X. So things depend on the module
> load order.
> 
> The obvious solution is to link the OF stuff into the module, but
> this also won't work, since modules have only one entry (and exit)
> point. So there is no way* to hook our OF helpers into the module.

Well, right, we need the bus notifier to be registered before any
device gets added ... which mean from the same module_init that
registers the bus itself. A bit annoying ...

> * Well, there is one solution to this problem. We can implement
> arch-specific init_module and cleanup_module entry/exit points,
> where we can load/unload the OF hooks. This is quite easy, but
> may look ugly. I could show the drafts.

Yuck :-)

Cheers,
Ben.


