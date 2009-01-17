Return-Path: <linux-kernel-owner+w=401wt.eu-S933375AbZAQAR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375AbZAQAR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 19:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762963AbZAQARU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 19:17:20 -0500
Received: from mail.impinj.com ([206.169.229.170]:45860 "EHLO earth.impinj.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762898AbZAQART (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 19:17:19 -0500
From: Vadim Lobanov <vlobanov@speakeasy.net>
To: Thomas Dahlmann <dahlmann.thomas@arcor.de>
Subject: Re: amd5536udc interrupts bug
Date: Fri, 16 Jan 2009 16:17:18 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.9-159.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <49661E83.2070703@arcor.de> <200901141449.37246.vlobanov@speakeasy.net> <496F012C.9020004@arcor.de>
In-Reply-To: <496F012C.9020004@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901161617.18351.vlobanov@speakeasy.net>
X-OriginalArrivalTime: 17 Jan 2009 00:17:18.0626 (UTC) FILETIME=[F5550020:01C97838]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009 01:26:04 Thomas Dahlmann wrote:
> > It seems that the ultimate cause for all this strangeness was a mis-wired
> > board: the vendor at long last admitted that the VBUS signal is not
> > connected in the hardware. Why they didn't simply document this fact, and
> > thereby save me a lot of wasted effort, remains a mystery.
> >
> > As a workaround, they suggested setting bit 0x00000010 in the ctl
> > register, which is strangely enough inside the "reserved" space according
> > to the AMD data book. Worth a shot, I thought. After hacking up the
> > amd5536udc driver even more to do this operation at load time, the
> > register states change to:
> >
> > cap=0x000083EA
> > mux=0x00000007
> > ctl=0x00000193
> >
> > Seems that a few other "reserved" bits also raised in response. (I still
> > do not understand exactly how they wired up the CS5536 IO chip to be
> > different from the data book, but oh well.) In this mode, the USB link is
> > finally detected, and the board is finally able to enumerate itself as a
> > g_zero device.
>
> This reserved bit seems to be an alias to the earlier mentioned PUEN bit
> which allows to connect the pull up manually regardless of VBUS.
> You will find that bit at page 276 in
>
> http://www.amd.com/files/connectivitysolutions/aufamily/au1200/32798e_Au120
>0_ds.pdf
>
> If you compare the registers you will find that UDC controller of
> Au1200 is 99.9% compatible with UDC of CS5536. Same for
> CS5536 UOC and Au1200 OTG Controller. But OTG Controller of
> Au1200 has more functionality and bits.
>
> Unfortunately this bit is not the complete solution for your problem.
> When setting PUE then connect and disconnect events cannot be
> detected by UDC. If you disconnect and connect again you
> probably will notice that there will be no new enumeration as
> expected.

Interestingly enough, when running in this configuration, unplugging and 
replugging the cable does cause a re-enumeration. Hmmmm.

-- Vadim Lobanov

