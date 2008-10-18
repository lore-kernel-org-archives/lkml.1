Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbYJRGlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbYJRGlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 02:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYJRGlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 02:41:07 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:40459 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbYJRGlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 02:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=scS6uW3aqKfgi5QtTN3aOABWcfiAQMu6uK+GYQOoPd6NJiPNCG+zM1LQttMmeoFSsz
         m/0jv2R/T0EpInSjClk+ufPa19fiHJsZWB3dbCT6azY2V1aptzErLI0CgyEV8NAdoA+d
         xwi6C2SuIjFX9iPgS6b28o0eKLoiygcjTwCI8=
Message-ID: <a4423d670810172341y5ae5542jea66ead938ba652d@mail.gmail.com>
Date: Sat, 18 Oct 2008 10:41:02 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: 2.6.27-05178-g2e532d6: list_add corruption
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810171617490.21410@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <a4423d670810171220t4d5602fekcb66e18758149925@mail.gmail.com>
	 <Pine.LNX.4.64.0810171617490.21410@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9I6fUdq025421

> This is very likely to be caused by a patch that went in a few days ago.> Already posted a fix to Andrew.>
Is it the same problem? 2.6.27-05577-g0cfd810
BUG eventpoll_epi: Poison overwritten-----------------------------------------------------------------------------INFO: 0xf2ac768c-0xf2ac7693. First byte 0xc instead of 0x6bINFO: Allocated in sys_epoll_ctl+0x120/0x405 age=21753 cpu=0 pid=1936INFO: Freed in ep_remove+0x7f/0x86 age=3964 cpu=0 pid=1936INFO: Slab 0xc16568e0 objects=32 used=29 fp=0xf2ac7680 flags=0x400000c3INFO: Object 0xf2ac7680 @offset=1664 fp=0xf2ac7f80
Bytes b4 0xf2ac7670:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5aZZZZZZZZZZZZZZZZ  Object 0xf2ac7680:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 0c 7d b1 f2kkkkkkkkkkkk.}â• Ğ   Object 0xf2ac7690:  0c 15 a7 f2 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b..â•–Ğ kkkkkkkkkkkk  Object 0xf2ac76a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6bkkkkkkkkkkkkkkkk  Object 0xf2ac76b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6bkkkkkkkkkkkkkkkk  Object 0xf2ac76c0:  6b 6b 6b a5                                     kkkâ•” Redzone 0xf2ac76c4:  bb bb bb bb                                     â•©â•©â•©â•© Padding 0xf2ac76ec:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5aZZZZZZZZZZZZZZZZ Padding 0xf2ac76fc:  5a 5a 5a 5a                                     ZZZZPid: 1936, comm: rtorrent Not tainted 2.6.27-05577-g0cfd810 #1Call Trace: [<c0161628>] print_trailer+0xe1/0xe9 [<c01616b1>] check_bytes_and_report+0x81/0xa4 [<c01617a9>] check_object+0xa5/0x160 [<c0162ceb>] __slab_alloc+0x420/0x4c7 [<c0138d45>] ? trace_hardirqs_on+0xb/0xd [<c01630d4>] kmem_cache_alloc+0x62/0xaf [<c0187485>] ? sys_epoll_ctl+0x120/0x405 [<c0187485>] ? sys_epoll_ctl+0x120/0x405 [<c0187485>] sys_epoll_ctl+0x120/0x405 [<c025d720>] ? trace_hardirqs_on_thunk+0xc/0x10 [<c0102ea9>] sysenter_do_call+0x12/0x35FIX eventpoll_epi: Restoring 0xf2ac768c-0xf2ac7693=0x6b
FIX eventpoll_epi: Marking all objects usedÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
