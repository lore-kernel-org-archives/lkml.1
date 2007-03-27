Return-Path: <linux-kernel-owner+w=401wt.eu-S934170AbXC0Siz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170AbXC0Siz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934169AbXC0Siz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:38:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38151 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934167AbXC0Six (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:38:53 -0400
Message-ID: <460964BA.8090101@garzik.org>
Date: Tue, 27 Mar 2007 14:38:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Rustad <mrustad@gmail.com>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
References: <Pine.LNX.4.64.0703241232580.11608@p34.internal.lan> <4608B2B9.7090503@garzik.org> <ACBD2F44-03C7-49BE-9A2F-ABF7078BCC5E@gmail.com>
In-Reply-To: <ACBD2F44-03C7-49BE-9A2F-ABF7078BCC5E@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Rustad wrote:
> reorder any queued operations. Of course if you really care about your 
> data, you don't really want to turn write cache on.

That's a gross exaggeration.  FLUSH CACHE and FUA both ensure data 
integrity as well.

Turning write cache off has always been a performance-killing action on ATA.


> Also the controller used can have unfortunate interactions. For example 
> the Adaptec SAS controller firmware will never issue more than two 
> queued commands to a SATA drive (even though the firmware will happily 
> accept more from the driver), so even if an attached drive is capable of 
> reordering queued commands, its performance is seriously crippled by not 
> getting more commands queued up. In addition, some drive firmware seems 
> to try to bunch up queued command completions which interacts very badly 
> with a controller that queues up so few commands. In this case turning 
> NCQ off performs better because the drive knows it can't hold off 
> completions to reduce interrupt load on the host – a good idea gone 
> totally wrong when used with the Adaptec controller.

All of that can be fixed with an Adaptec firmware upgrade, so not our 
problem here, and not a reason to disable NCQ in libata core.


> Today SATA NCQ seems to be an area where few combinations work well. It 
> seems so bad to me that a whitelist might be better than a blacklist. 
> That is probably overstating it, but NCQ performance is certainly a big 
> problem.

Real world testing disagrees with you.  NCQ has been enabled for a while 
now.  We would have screaming hordes of users if the majority of 
configurations were problematic.

	Jeff


