Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZG0Qyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZG0Qyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 12:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZG0Qyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 12:54:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47652 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751429AbZG0Qyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 12:54:52 -0400
Date: Mon, 27 Jul 2009 17:55:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ferenc Wagner <wferi@niif.hu>,
       Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bisected] [Bug #13821] Replugging USB serial converter uses
 new device node
Message-ID: <20090727175525.20ac4869@lxorguk.ukuu.org.uk>
In-Reply-To: <20090727164857.GA8908@Pilar.aei.mpg.de>
References: <87zlaqcec1.fsf@tac.ki.iif.hu>
	<Pine.LNX.4.44L0.0907271217441.5217-100000@iolanthe.rowland.org>
	<20090727164857.GA8908@Pilar.aei.mpg.de>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Another thing to check is whether this patch (not yet merged) fixes it:
> > 
> > 	http://marc.info/?l=linux-usb&m=124825571403844&w=2
> 
> No, unfortunately it does not fix it. I've just tested it.

I wouldn't expect it to.

In the ppp case you have this occuring on an unplug

	USB layer
		unplug
		hangup tty
	PPPD
		SIGHUP
		ouch
		log stuff
		close down

However at the same time that PPPD is logging stuff and closing down th
USB layer is going to see the replug if you just unplug/replug quickly
and in that case you will get ttyUSB1. That aspect is timing dependant.

If everything has closed down and given the port back before you replug
it you should get ttyUSB0 again.
#
