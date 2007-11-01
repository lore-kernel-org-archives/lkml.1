Return-Path: <linux-kernel-owner+w=401wt.eu-S1759235AbXKAXwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759235AbXKAXwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755320AbXKAXwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:52:42 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:25461 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754941AbXKAXwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:52:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=It3Nq0bSvpIc0tAGKAyatYY54k19LLCl40cAH1r+kh/Uogkxly64O12MGrIT59okvuhnga5LvLHTUAIVtM/4ewzAdje34XEIrieczYpeF4QRrGR1qyw4drpZNXxI9SSudFaLzy5qkdEsxvoIrD6woxWGMa1V3yERJ4OsND73TW0=  ;
X-YMail-OSG: TCV6th8VM1lhRj9FZuiLRytU8qeWj2gZd_wHiKqEJrD07zmKjmOOO.d.LDZ7Fdn7RD_pKuaPdg--
From: David Brownell <david-b@pacbell.net>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] let USB_USBNET always select MII
Date: Thu, 1 Nov 2007 16:52:39 -0700
User-Agent: KMail/1.9.6
Cc: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200711012024.57412.toralf.foerster@gmx.de> <20071101222524.GB7227@stusta.de>
In-Reply-To: <20071101222524.GB7227@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711011652.39601.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 November 2007, Adrian Bunk wrote:
> All this USB_USBNET_MII trickery is simply not worth it considering how 
> few code it saves.

Depends on what systems you're talking about.  Forcing unused
code into the kernel is not free, especially if that's made into
a design policy and applied repeatedly to many subsystems.


> As a side effect, this also fixes the following compile error reported 
> by Toralf Förster:

Why not just fix the thing which changed and broke the build?

Or if reverse dependencies can't be made to work sanely, then
have those Ethernet-adapter minidrivers depend on NET_ETHERNET
and then select MII.  (To make the relationships be simple
enough that current Kconfig can handle them.)

I have a fair number of usbnet devices.  Not one of them needs
MII or NET_ETHERNET.

- Dave

