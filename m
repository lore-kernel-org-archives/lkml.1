Return-Path: <linux-kernel-owner+w=401wt.eu-S948413AbXHMQ27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S948413AbXHMQ27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967835AbXHMPYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:24:19 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59226 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S972787AbXHMPYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:24:15 -0400
Message-ID: <46C0779D.3010401@s5r6.in-berlin.de>
Date: Mon, 13 Aug 2007 17:24:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: lepton <ytht.net@gmail.com>
CC: lkm <linux-kernel@vger.kernel.org>, bcollins@debian.org,
       linux1394-user@lists.sourceforge.net
Subject: Re: I have two 1394 port in my computer, why did I get only one eth1394
 interface?
References: <20070813123555.GA6276@router.lepton.home>
In-Reply-To: <20070813123555.GA6276@router.lepton.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(added Cc: linux1394-user)

lepton wrote:
>    My computer has two 1394 port, one is in the front panel, and another
> is in the back. I found with linux 1394 ethernet support, I only get one
> ethernet device named eth1.
>    After read code, I found author says "This is where we add all of
> our ethernet * devices. One for each host."
>    Then my question is:
>    1. Is it possible to use every 1394 port as a ethernet device?

Yes.

>    2. If not, which port should I plug my firewire line into?

Any one port.  Note though that front panel connectors may have a
slightly reduced signal quality due to the onboard pin headers, jumper
cable, and front panel board traces.

>    3. If I must plug my firewire line in some port, can I change the
> default port to use?

Not necessary.

To explain this further:  Each FireWire controller comes in two parts
(which are sometimes integrated on a single chip though):  The link
layer controller and the PHY(sical bus interface).  The PHY may have
several ports, but all of these ports belong to the same FireWire bus.
The PHY not only connect the link layer controller with each port, it
also acts as hub/repeater between those ports.

There are a few FireWire controller cards which come with two, three, or
even four link layer controllers on the same card.  These cards too have
one PHY per link layer controller, i.e. two/ three/ four PHYs on the
card.  These cards appear to the ieee1394 drivers like multiple cards
(and multiple FireWire buses), hence will give you multiple eth1394
network interfaces just like multiple separate cards will do.

So, you get as many eth1394 interfaces as there are link layer
controllers.  You can check the number of present link layer controllers
by lspci.
-- 
Stefan Richter
-=====-=-=== =--- -==-=
http://arcgraph.de/sr/
