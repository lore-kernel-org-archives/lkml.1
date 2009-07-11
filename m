Return-Path: <linux-kernel-owner+w=401wt.eu-S1753257AbZGKEeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbZGKEeL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 00:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbZGKEeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 00:34:00 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:47682 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZGKEd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 00:33:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l5EzSDUrI41uQc2aoj7bXontowWQ0sM4w7N9kzNYe+RE8V989FnUmJ9Mf3S6AgchxZ
         ie8oL2iKqSLdnC9UMpMNtZNw9vWGyk99/BT4XBugOIx3vac9UElHYNluIXeAJGoV/NC/
         04btM6YLdWG+pcEEZtDv+CDMUAxx6Mv1gNF1k=
MIME-Version: 1.0
In-Reply-To: <4A55EC95.5000309@gmail.com>
References: <4A54FB81.30302@gmail.com>
	 <3ace41890907081449m3ad6c4fdt55781848eedaec1e@mail.gmail.com>
	 <4A551B43.3020104@gmail.com>
	 <3ace41890907082118h52764c98i7ebd9365bcd69b2c@mail.gmail.com>
	 <4A5575C1.8090403@lwfinger.net>
	 <3ace41890907090347m1f337731rb09b90327664ed5@mail.gmail.com>
	 <4A55D123.5090802@gmail.com>
	 <3ace41890907090540v6895e2bay8128c0d565a7a55f@mail.gmail.com>
	 <4A55EC95.5000309@gmail.com>
Date: Sat, 11 Jul 2009 05:33:57 +0100
Message-ID: <3ace41890907102133r1cbcf063vb70f7cb350e813ec@mail.gmail.com>
Subject: Re: [PATCH] wireless: fix supported cards for rtl8187
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Linux wireless <linux-wireless@vger.kernel.org>,
       Przemyslaw Kulczycki <azrael@autocom.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/9 Marcin Slusarz <marcin.slusarz@gmail.com>:

> Look, support for Ralink chipsets is a mess. They are supported by too sets
> of drivers - Ralink's ugly as hell but working staging drivers (rt2860,
> rt2870, rt3070, soon rt3090) and properly developed but lagging rt2x00
> drivers (RT2400PCI, RT2500PCI, RT61PCI, RT2500USB, RT73USB, RT2800USB).
>
> Theoretically my WUSB54GCv3 is supported by RT2800USB (which was added during
> 2.6.31 merge window), but it doesn't work. With tiny patch added to rt3070
> (just usb id) my card works. Some day rt2x00 drivers will be better than Ralink's,
> but right now they are not.
>
> So I wouldn't like to encourage any of them. I just wanted to fix clearly
> wrong help text which stated that rtl8187 (Realtek's chipset!) supports
> all WUSB54GC cards.

I think you mis-read the Kconfig message. GPL clause 11:
...PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE...

The linux kernel never claim to cover *all* of anything, and in
particular, the message you refers to is meant to read '*some*
WUSB54GC are known to work', YMMV. I think adding pointers/info to v1
and3 would be better if you want to add 'v2' to it; particularly since
Gabor has pointed out that v1/v2/v3 all have different USB ids and a
full set of kernel modules will bind to the different devices
correctly, so the message is only for people who has a new/unknown
device and want to experiment (and expect to have some failures). And
to be honest, there is a device called rtl8187se, which isn't an
rtl8187 at all and don't have much in common. If you start insisting
the rtl8187 Kconfig message should have an extra 5 letters say 'not
se', I would rather you say 'rtl8187se is covered by ..., which is in
staging phase'. (the se driver is, the last time I heard, in staging
and not working and nobody is working on it to make it work, which is
worse than your situation).

The situation with Ralink drivers isn't that different in other
vendors - Realtek provides a vendor driver for rtl8187 called "r8187"
and there is a community driver rtl8187; Atheros provides a vendor
driver for Zydas zd1211 and there is a community driver zd1211rw. I
don't think this "wouldn't like to encourage any of them" attitude is
helping anybody. In both of the Realtek case and the Zydas case,
people tolerated the co-existences of both (and sometimes with
ndiswrapper also) for many months and studied the vendor drivers (+
ndiswrapper) and eventually improve the community driver.
Driver codes don't grow on trees - if you 'wouldn't like to encourage
any of them', maybe you should not be using linux at all.
