Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbYKVPNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbYKVPNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 10:13:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbYKVPNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 10:13:34 -0500
Received: from bu3sch.de ([62.75.166.246]:41785 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbYKVPNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 10:13:33 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Yuval Hager <yuval@avramzon.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sat, 22 Nov 2008 16:13:00 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
References: <200811151801.02369.yuval@avramzon.net> <4926FDB3.2030701@lwfinger.net> <200811220839.32674.yuval@avramzon.net>
In-Reply-To: <200811220839.32674.yuval@avramzon.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811221613.00303.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008 07:39:24 Yuval Hager wrote:
> On Friday 21 November 2008, Larry Finger wrote:
> > Yuval,
> >
> > Michael Buesch wrote:
> > > Can you dump PCI config space and SSB registers (TMSLOW, maybe others,
> > > too). It looks like a random bus write disabled the device.
> >
> > Please incorporate the following patch and run your system. In addition,
> > run the following command when the wireless is working and after it fails:
> >
> > sudo lspci -d 14e4:4312 -x
> >
> 
> When the wireless is working:
> $ lspci -d 14e4:4312 -x
> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 02)
> 00: e4 14 12 43 06 01 10 00 02 00 80 02 08 00 00 00
> 10: 04 c0 ff fd 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 71 13
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 0a 01 00 00
> 
> After it fails:
> $ lspci -d 14e4:4312 -x
> 02:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g (rev 02)
> 00: e4 14 12 43 00 00 10 00 02 00 80 02 00 00 00 00
                  ^^                      ^^
Somebody disabled MMIO and busmastering.
And somebody cleared the CACHE_LINE_SIZE register.

> 10: 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 20: 00 00 00 00 00 00 00 00 00 00 00 00 3c 10 71 13
> 30: 00 00 00 00 40 00 00 00 00 00 00 00 00 01 00 00

-- 
Greetings Michael.
