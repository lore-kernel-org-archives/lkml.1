Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbXEaX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbXEaX1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:27:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbXEaX04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:26:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47982 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXEaX0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:26:55 -0400
Message-ID: <465F59BB.9040909@garzik.org>
Date: Thu, 31 May 2007 19:26:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Daniel J Blueman <daniel.blueman@gmail.com>, bzolnier@gmail.com,
       linux-ide@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Compact Flash performance...
References: <6278d2220705301510y2d81f69eu38fb778d32de05e1@mail.gmail.com>	 <465E3FF0.9010709@rtr.ca>	 <6278d2220705310222rde9ad28ndfd8feced84a3c6f@mail.gmail.com>	 <465EBE20.6090803@rtr.ca>	 <6278d2220705311025q6ee030e2kd44b7302a50ac902@mail.gmail.com>	 <465F360D.6020603@rtr.ca> <6278d2220705311439x40f7b1c1l7cef54acd2e8fcea@mail.gmail.com> <465F4ED0.10508@rtr.ca>
In-Reply-To: <465F4ED0.10508@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> To maximize throughput, some kind of host-queuing would be needed,
> or just have the driver sit in a tight loop, starting the next I/O
> immediately when the previous one finishes.  Linux isn't that quick (yet).


I was talking on IRC with Tejun just recently.  There are several 
controllers (and/or "situations") like this, where some amount of host 
queueing would permit greater throughput, even when NCQ is not 
supported.  sata_sx4 is the most dramatic example, where host queueing 
could potentially increase speed by a factor of 10 or more, since it is 
penalized by an awful two-irq-per-command (w/ a per-host bottleneck to 
boot) setup.  Silicon Image has a "command buffer".  And overall, I 
designed ->qc_prep() hook separate from ->qc_issue() to enable the 
prepartion of multiple commands such that it only takes a simple "go" 
I/O to start a transaction, immediately after the previous one ends.

	Jeff


