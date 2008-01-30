Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYA3UX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYA3UX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:23:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbYA3UXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:23:14 -0500
Received: from ns.gsystems.sk ([62.176.172.50]:38275 "EHLO www.gsystems.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756990AbYA3UXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:23:12 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: jgarzik@pobox.com
Subject: Re: Compex FreedomLine 32 PnP-PCI2 broken with de2104x
Date: Wed, 30 Jan 2008 21:23:06 +0100
User-Agent: KMail/1.9.7
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
References: <200801262158.12016.linux@rainbow-software.org>
In-Reply-To: <200801262158.12016.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801302123.07783.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 January 2008 21:58:10 Ondrej Zary wrote:
> Hello,
> I was having problems with these FreedomLine cards with Linux before but
> tested it thoroughly today. This card uses DEC 21041 chip and has TP and
> BNC connectors:
>
> 00:12.0 Ethernet controller [0200]: Digital Equipment Corporation DECchip
> 21041 [Tulip Pass 3] [1011:0014] (rev 21)
>
>
> de2104x driver was loaded automatically by udev and card seemed to work.
> Until I disconnected the TP cable and putting it back after a while. The
> driver then switched to (non-existing) AUI port and remained there. I tried
> to set media to TP using ethtool - and the whole kernel crashed because of
> BUG_ON(de_is_running(de));
> in de_set_media(). Seems that the driver is unable to stop the DMA in
> de_stop_rxtx().
>
> I commented out AUI detection in the driver - this time it switched to BNC
> after unplugging the cable and remained there. I also attempted to reset
> the chip when de_stop_rxtx failed but failed to do it.
>
> Then I found that there's de4x5 driver which supports the same cards as
> de2104x (and some other too) - and this one works fine! I can plug and
> unplug the cable and even change between TP and BNC ports just by
> unplugging one and plugging the other cable in. Unfortunately, this driver
> is blacklisted by default - at least in Slackware and Debian.
>
> The question is: why does de2104x exist? Does it work better with some
> hardware?
>
> BTW. Found that the problem exist at least since 2003:
> http://oss.sgi.com/archives/netdev/2003-08/msg00951.html

Does the de2104x driver work correctly for anyone?

-- 
Ondrej Zary
