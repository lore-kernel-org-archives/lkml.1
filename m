Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbXLHU11@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbXLHU11 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:27:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXLHU1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:27:20 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:3485 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbXLHU1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:27:20 -0500
From: "David Schwartz" <davids@webmaster.com>
To: "Theodore Tso" <tytso@mit.edu>, "Mike McGrath" <mmcgrath@redhat.com>,
       "Jon Masters" <jonathan@jonmasters.org>,
       "Matt Mackall" <mpm@selenic.com>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Ray Lee" <ray@madrabbit.org>, "Adrian Bunk" <bunk@kernel.org>,
       "Marc Haber" <mh+linux-kernel@zugschlus.de>,
       <linux-kernel@vger.kernel.org>
Subject: RE: Why does reading from /dev/urandom deplete entropy so much?
Date: Sat, 8 Dec 2007 12:26:27 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEHJILAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <475AE2ED.3050700@garzik.org>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Sat, 08 Dec 2007 12:27:23 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Sat, 08 Dec 2007 12:27:23 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> heh, along those lines you could also do
>
> 	dmesg > /dev/random
>
> <grin>
>
> dmesg often has machine-unique identifiers of all sorts (including the
> MAC address, if you have an ethernet driver loaded)
>
> 	Jeff

A good three-part solution would be:

1) Encourage distributions to do "dmesg > /dev/random" in their startup
scripts. This could even be added to the kernel (as a one-time dump of the
kernel message buffer just before init is started).

2) Encourage drivers to output any unique information to the kernel log. I
believe all/most Ethernet drivers already do this with MAC addresses.
Perhaps we can get the kernel to include CPU serial numbers and we can get
the IDE/SATA drivers to include hard drive serial numbers. We can also use
the TSC, where available, in early bootup, which measures exactly how long
it took to get the kernel going, which should have some entropy in it.

3) Add more entropy to the kernel's pool at early startup, even if the
quality of that entropy is low. Track it appropriately, of course.

This should be enough to get cryptographically-strong random numbers that
would hold up against anyone who didn't have access to the 'dmesg' output.

DS


