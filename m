Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbZIDS4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbZIDS4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:56:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933824AbZIDS4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:56:06 -0400
Received: from bu3sch.de ([62.75.166.246]:43252 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933823AbZIDS4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:56:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupt handlers broken?
Date: Fri, 4 Sep 2009 20:55:52 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200908161153.14081.mb@bu3sch.de> <alpine.LFD.2.00.0908171411410.2782@localhost.localdomain> <200908171430.32146.mb@bu3sch.de>
In-Reply-To: <200908171430.32146.mb@bu3sch.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909042055.55385.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 August 2009 14:30:31 Michael Buesch wrote:
> Also works. Thanks.
> 
> Tested-by: Michael Buesch <mb@bu3sch.de>

Hm, I've got a strange problem here related to threaded IRQs and rmmod.

If I do this sequence, it crashes the machine:
request_threaded_irq();
free_irq();
rmmod module
modprobe module
request_threaded_irq();
*boom*

Here are some oops messages. These are almost always different, so I
guess it crashes in IRQ context at random places when the IRQ triggers.
http://bu3sch.de/misc/irq_crash1.JPG
http://bu3sch.de/misc/irq_crash2.JPG

It seems to be a NULL pointer dereference somewhere, but I can't locate it.
Note that it does not happen, if I omit the rmmod.

-- 
Greetings, Michael.
