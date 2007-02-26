Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbXBZQkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbXBZQkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 11:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030316AbXBZQkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 11:40:41 -0500
Received: from stargate.synerway.com ([84.14.10.249]:32939 "EHLO
	stargate.synerway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbXBZQkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 11:40:41 -0500
X-Greylist: delayed 1935 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Feb 2007 11:40:41 EST
Date: Mon, 26 Feb 2007 17:08:24 +0100
From: Pascal GREGIS <pgs@synerway.com>
To: linux-kernel@vger.kernel.org
Subject: need some help on a backport of r8169
Message-ID: <20070226160824.GB14593@venus.synerway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-OriginalArrivalTime: 26 Feb 2007 16:04:01.0588 (UTC) FILETIME=[BB17E740:01C759BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I am experiencing a big fight with a Realtek RTL8168 ethernet card that I need to use with a 2.6.11.11 kernel.

Here is my problem :
the RTL8168 (which seems to be the PIC-express version of the RTL8169) isn't recognized by the 2.6.11.11 kernel.
So I tried the r1000 driver supplied by Realtek, which recognizes my RTL8168 card but doesn't do what I want.
In fact, it only supports ethtool for speed control and always uses autonegotiation to force a mode, which is also the behaviour of the r8169 driver but doesn't fit my needs because some of my company's clients use network switches that do not support autonegotiation.

I must precise that I previously succeeded to backport the support for mii-tool in the r8169 driver from the 2.6.20 kernel to the 2.6.11.11, which allows me to effectively force the speed without using autonegotiation.
Ok, but that was for the RTL8169 card, already supported in the 2.6.11.11 kernel, now I need to support a RTL8168 one.

So I tried a 2.6.20 kernel with this card and I saw that it was supported by the r8169 driver.
So I decided to backport some of this driver to add the RTL8168 in it for the 2.6.11.11 kernel.
I thought it was easy and just required to add some references (pci id ...) but sadly it isn't, and my patch results in a kernel panic when I turn the interface up.

Could anyone take a look at my patch and tell me what is missing, or what is wrong?

Or if you have other suggestions, do not hesitate, if you think I'd better patch the r1000 driver to add mii-tool support (it didn't seem so easy) or anything else, but please don't suggest me to change my network switches, these are not mines so I cannot do anything for this.
Also I cannot change my entire kernel for the moment.

Here you can find my patch :
http://www.synerway.net/patch/r8169-backport.patch

it adds mii-tool support and TRIES to add RTL8168 support.

Thank you for any help

Pascal

