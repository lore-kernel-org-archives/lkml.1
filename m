Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZDKEPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZDKEPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 00:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZDKEPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 00:15:34 -0400
Received: from smtp01.bis.na.blackberry.com ([216.9.248.48]:37083 "EHLO
	smtp01.bis.na.blackberry.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbZDKEPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 00:15:33 -0400
X-Greylist: delayed 582 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Apr 2009 00:15:33 EDT
X-rim-org-msg-ref-id: 900814656
Message-ID: <900814656-1239422746-cardhu_decombobulator_blackberry.rim.net-2124207137-@bxe1152.bisx.prod.on.blackberry>
Reply-To: tytso@mit.edu
X-Priority: Normal
References: <E1Ls9pZ-0004IF-FZ@closure.thunk.org> <20090410175723.GA20983@elf.ucw.cz> <200904102008.59932.rjw@sisk.pl><b6a2187b0904101812x270fbbc1i55918fd5ff98ccea@mail.gmail.com>
In-Reply-To: <b6a2187b0904101812x270fbbc1i55918fd5ff98ccea@mail.gmail.com>
Sensitivity: Normal
Importance: Normal
To: "Jeff Chua" <jeff.chua.linux@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Pavel Machek" <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?
From: "Theodore Tso" <tytso@mit.edu>
Date: Sat, 11 Apr 2009 04:04:51 +0000
Content-Type: text/plain
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n3B4Fmqu031869

So I tried to do a bisect using a reduced config, and I wasn't able to reproduce.  So I went back to 2.6.30-rc1 and started playing with configurations.   I was able to finally get a reproduction, and I found that the af_packet module seems to be responsible.   If I move the modules directory out of the way and reboot, then manually insmod the af_packet module, then suspend, it fails by hanging with the flashing moon LED.  If I reboot and don't load the af_packet module, the suspend works.   Needless to say this falls into the WTF category.   I will do more testing to see what's up...

     - Ted

-----Original Message-----
From: Jeff Chua <jeff.chua.linux@gmail.com>

Date: Sat, 11 Apr 2009 09:12:28 
To: Rafael J. Wysocki<rjw@sisk.pl>
Cc: Pavel Machek<pavel@ucw.cz>; Theodore Ts'o<tytso@mit.edu>; <linux-kernel@vger.kernel.org>
Subject: Re: suspend-to-ram broken on X61 thinkpads in 2.6.30-rc1?


On Sat, Apr 11, 2009 at 2:08 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> Can you attach yours, so that we could compare, please?

Attached is my .config.

> I meant please test the kernel where commit
> 0a0c5168df270a50e3518e4f12bddb31f8f5f38f is the head.  It is possible
> that one of the commits immediately following it broke things.  If that's
> the case, this kernel will work for you.

I'll do that now.

Thanks,
Jeff.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
