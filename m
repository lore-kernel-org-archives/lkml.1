Return-Path: <linux-kernel-owner+w=401wt.eu-S1752034AbXB0TIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbXB0TIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXB0TIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:08:46 -0500
Received: from inetc.connecttech.com ([64.7.140.42]:4144 "EHLO
	inetc.connecttech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbXB0TIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:08:45 -0500
From: "Stuart MacDonald" <stuartm@connecttech.com>
To: "'Russell King'" <rmk+lkml@arm.linux.org.uk>,
       "'Rob Prowel'" <prowel@kuchera.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: RE: questions about 8250 uart support for adhoc boards
Date: Tue, 27 Feb 2007 14:06:04 -0500
Organization: Connect Tech Inc.
Message-ID: <028501c75aa2$54ae9d80$294b82ce@stuartm>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.6626
In-Reply-To: <20070227173844.GA10380@flint.arm.linux.org.uk>
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King [mailto:rmk@arm.linux.org.uk]
> After experimenting here, it turns out the reason is you're trying to
> configure a port with a zero base baud.  Unfortunately, it starts off
> as zero.

That explains why adding the fourport module fixed Rob's issue, as the
fourport code sets a uartclk value for its ports.

> However, when you try to change a port without specifying the 
> base baud,
> it is possible for the port to become "usable" and unless we enforce
> the "must not have zero base baud" rule we have the 
> possibility to oops
> the kernel via a divide by zero.
> 
> So, the answer is to specify the base baud when using setserial to
> configure new ports.

Would it be more intuitive to give ports the default uartclk of
1843200 at init time? That would avoid this issue, but would make the
baud rates come out wrong on hardware with a non-standard clock, if a
base baud wasn't specified.


From: Rob Prowel [mailto:prowel@kuchera.com] 
> your website address didn't work when I tried it...

The website may have been down on the weekend for maintenance. Please
try again.

..Stu

-- 
We make multiport serial products.
http://www.connecttech.com/
(800) 426-8979

