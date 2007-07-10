Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbXGJSXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbXGJSXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 14:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763286AbXGJSWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 14:22:55 -0400
Received: from rtr.ca ([64.26.128.89]:3675 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762593AbXGJSWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 14:22:54 -0400
Message-ID: <4693CE7A.5070502@rtr.ca>
Date: Tue, 10 Jul 2007 14:22:50 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Bruce Allen <ballen@gravity.phys.uwm.edu>, Mark Lord <liml@rtr.ca>,
       David Greaves <david@dgreaves.com>, Douglas Gilbert <dougg@torque.net>,
       Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kai Makisara <Kai.Makisara@kolumbus.fi>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Jan Dvorak <fermentol@gmail.com>,
       Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <bruce.allen@aei.mpg.de>
Subject: Re: [smartmontools-support] SMART problems in 2.6.22
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu> <Pine.LNX.4.63.0707082003360.23123@trinity.phys.uwm.edu> <20070709233535.GA5020@atlantic.linksys.moosehall>
In-Reply-To: <20070709233535.GA5020@atlantic.linksys.moosehall>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Spiers wrote:
> On Sun, Jul 08, 2007 at 08:14:10PM -0500, Bruce Allen wrote:
>> On Sun, 8 Jul 2007, Bruce Allen wrote:
>>..
>> http://article.gmane.org/gmane.linux.utilities.smartmontools/4704/match=diamondmax
>>
>> Again, this indicates that SMART is enabled.  But it's not clear what the 
>> kernel version here is.  The report indicates that the problem started 
>> with an FC7 kernel upgrade

So it's a bug in the sata_nv.c port driver.

In particular, I see this in the bug report:

>Jun 30 10:23:42 atlantic kernel: ata1: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1501000 status 0x1540 next cpb count 0x0 next cpb idx 0x0

That looks a bit strange, because the driver goes to some effort
to prevent these kind of commands from ever being issued "in ADMA mode",
precisely because there's no way to do a tf_read in that mode.

Mmm.. buggy somewhere in there.
