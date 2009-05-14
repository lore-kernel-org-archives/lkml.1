Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029AbZENRqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbZENRqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbZENRpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:45:34 -0400
Received: from emroute2.ornl.gov ([160.91.86.17]:41725 "EHLO emroute2.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399AbZENRpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:45:33 -0400
Date: Thu, 14 May 2009 13:45:33 -0400
From: David Dillow <dave@thedillows.org>
Subject: Re: Realtek 8168D: no active link (2.6.29.2)
In-reply-to: <200905141208.n4EC8xh3017350@mercury.physics.adelaide.edu.au>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: Francois Romieu <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org
Message-id: <1242323133.32579.4.camel@lap75545.ornl.gov>
MIME-version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10)
Content-type: text/plain
Content-transfer-encoding: 7bit
References: <200905141208.n4EC8xh3017350@mercury.physics.adelaide.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 21:38 +0930, Jonathan Woithe wrote:
> Hi again
>
> Following up on my previous email, it seems that the stock kernel r8169
> driver is now working with the card in this machine ever since I tried the
> Realtek driver version 8.012.00.  It's almost as if the Realtek driver
> "unlocked" something on the chip (eg: activated the PHY), the status of
> which is remembered across reboots and hard powercycles.

It's worth noting that a power cycle may not clear everything out, as
there is likely standby power being supplied even with you have the
machine off. You can be sure by disconnecting the mains power to the
power supply for 30 seconds or so -- I've seen some motherboards with
large caps that take a while to drain.

It would be interesting to see if your problems come back after doing
this. Also, if you have another machine on the gigabit network, it would
be interesting to do 'nc -l 9000 > /dev/null' and 'nc target 9000
< /dev/zero' on the other and see if a ping between the machine
eventually stops working. This reliably hangs my 8168d card at home, but
it comes back with an ifdown/ifup sequence.

Dave
