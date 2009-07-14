Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZGNJIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZGNJIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZGNJIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:08:20 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:48407 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZGNJIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:08:19 -0400
Date: Tue, 14 Jul 2009 11:07:37 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] Input: add MAX7359 key switch controller driver, v2
In-reply-to: <20090714082452.GH2822@dtor-d630.eng.vmware.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Kim Kyuwon'" <q1.kim@samsung.com>,
       "'Trilok Soni'" <soni.trilok@gmail.com>,
       "'Kim Kyuwon'" <chammoru@gmail.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       "'Kyungmin Park'" <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <002a01ca0462$8b750a90$a25f1fb0$%szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
Thread-index: AcoEXJb6Y62+PJ69SnaqqqZJBcKy0gABGvow
References: <4A04E5EA.7000103@samsung.com>
 <5d5443650905091027w2b60f2ael520373790e6414c7@mail.gmail.com>
 <4d34a0a70905101934j320c03abl7e39af4fbfdf1f62@mail.gmail.com>
 <20090511031208.GA15208@dtor-d630.eng.vmware.com>
 <5d5443650906191038o797e0c3eu8234a56ee247ea68@mail.gmail.com>
 <5d5443650907130152t420e9426q762c24bdb1b29aae@mail.gmail.com>
 <20090713093147.GJ10819@dtor-d630.eng.vmware.com>
 <4A5BF6F0.6020403@samsung.com>
 <001801ca044c$428839d0$c798ad70$%szyprowski@samsung.com>
 <20090714082452.GH2822@dtor-d630.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tuesday, July 14, 2009 10:25 AM, Dmitry Torokhov wrote:

> On Tue, Jul 14, 2009 at 08:28:05AM +0200, Marek Szyprowski wrote:
> > Hello,
> > On Tuesday, July 14, 2009 5:10 AM, Kim Kyuwon wrote:
> > > Dmitry Torokhov wrote:
> > > > On Mon, Jul 13, 2009 at 02:22:10PM +0530, Trilok Soni wrote:
> > > >> I don't see this driver picked up yet in your -next branch. We should
> > > >> target this driver to be mainlined in next merge window. This is very
> > > >> important driver for some of the embedded systems, including palm pre
> > > >> :)
> > > > I was wondering if somebody could test the patch below and if it still
> > > > works then I will apply to the next branch. Thanks!
> > > >
> > >
> > > Dear Marek,
> > >
> > > Because I don't have the NCP board(which includes the max7359 keypad)
> > > now, I can't test this patch. Marek, could you please test this patch?
> >
> > I would like to, but I could not find the base version to which I can apply
> > that patch. I've tried v2 version posted in '[PATCH] Input: add MAX7359 key
> > switch controller driver, v2' mail from Sat 2009-05-09 04:10 with 2 patches
> > posted in replies to that main, but the latest patch still fails to apply.
> >
> > Could someone send me a complete patch, so I can do a test?
> >
> 
> Sending everything as attachments, maybe that will help...

Ok. I've did the tests.

MAX7359 keypad driver works after your patch, but reports much more events than
the previous version. In this test I pressed quickly the first button on the
keypad.

Old version:
NCP:~# hexdump /dev/input/event0
0000000 0037 0000 e733 000b 0001 00e7 0001 0000
0000010 0037 0000 e748 000b 0000 0000 0000 0000
0000020 0037 0000 94e2 000d 0001 00e7 0000 0000
0000030 0037 0000 94f3 000d 0000 0000 0000 0000


New version:
NCP:~# hexdump /dev/input/event0
0000000 0110 0000 4f07 0009 0004 0004 0000 0000
0000010 0110 0000 4f30 0009 0001 00e7 0001 0000
0000020 0110 0000 4f3b 0009 0000 0000 0000 0000
0000030 0110 0000 9d43 0009 0004 0004 003f 0000
0000040 0110 0000 9d5d 0009 0000 0000 0000 0000
0000050 0110 0000 fcb6 000a 0004 0004 0000 0000
0000060 0110 0000 fcd2 000a 0001 00e7 0000 0000
0000070 0110 0000 fcd9 000a 0000 0000 0000 0000
0000080 0110 0000 4ae9 000b 0004 0004 003f 0000
0000090 0110 0000 4b02 000b 0000 0000 0000 0000

Melfas-MCS-5000 touch screen driver stopped working after your patch. The 'v3' version worked fine here. Tests has been done on
2.6.30 kernel on NCP board (I had to cherrypick a gpio-matrix keypad driver to compile the updated MAX7359 driver, but this
shouldn't matter at all).

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


