Return-Path: <linux-kernel-owner+w=401wt.eu-S1422909AbXEDKEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422909AbXEDKEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422910AbXEDKEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:04:33 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:18732 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422909AbXEDKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EG4CuDwZbafmDu+qgkL4s7C0ubFpY8YX53oi7fMldKgYj9AD9p/8JMSRuANvLIy31ImUlidGise5OKYvc7JIO5QV0uI3+c0ZmDu94x2mgXbVhPkt5xyRLCbKDIKCVJgfUAWaXmDQLP1RX9HSrHcCi+4p39dC+u9q0M6IyJ2kExk=
Message-ID: <6278d2220705040304n6bfe14e8h7d3a1302315f36a5@mail.gmail.com>
Date: Fri, 4 May 2007 11:04:31 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Chris Adams" <cmadams@hiwaay.net>
Subject: Re: ExpressCard hotswap support?
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 May, 01:20, Chris Adams <cmadams@hiwaay.net> wrote:
> I've got a Thinkpad Z60m with an ExpressCard slot, and I got a Belkin
> F5U250 GigE ExpressCard (Marvell 88E8053 chip using sky2 driver).  It
> appears that Linux only recognizes it if I insert the card with the
> system powered off.  If I hot-insert the card, nothing happens (no
> messages logged, no PCI device shows up, nothing).

The BIOS initialises and powers up the downstream PCI express port
when it detects a card is present.

When Linux boots, it enumerates the bus and sees it, but does not do
prior configuration to enable, configure and cause link negotiation on
all PCI express ports I believe; this requires chipset and (sometimes
revision-) specific code, which wouldn't be so robust as the BIOS
doing the footwork.

I have the same problem on my Sony VGN-SZ240. The problem would be
addressed if the BIOS powered up all PCI express ports, but then this
would draw more power. Perhaps if just needs to do the hotplug
configuration correctly, but then older OSs may have problems?

> Does Linux support hotswapping ExpressCards?
>
> This is with Fedora Core 6 with all updates, kernel 2.6.20-1.2948.fc6.
-- 
Daniel J Blueman
