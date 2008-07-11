Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYGKNgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYGKNgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbYGKNgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:36:37 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:59587 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbYGKNgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:36:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZMboR+Y2xET2AP/ayV2ETJFndu98gr+3mKnaY4Ibb5m7tyluI/C3kjfY/WIFya0y2f
         4ANNfHJNzSeyQW+gkkGnINbM+betYHo80oez2Ov5VeXvGJwBJ+/NMsGdpwvHUKqWpkER
         LLNeH9dIPaChq9EwXiOzQ0ncgOkJes0i6Zgo4=
Message-ID: <19f34abd0807110636u4502c112t56b97218eb8b30d@mail.gmail.com>
Date: Fri, 11 Jul 2008 15:36:33 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "=?UTF-8?Q?T=C3=B6r=C3=B6k_Edwin?=" <edwintorok@gmail.com>
Subject: Re: today's linux-next fails to boot
Cc: linux-next@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4877400B.1000400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <4877400B.1000400@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6BDaofq024352

On Fri, Jul 11, 2008 at 1:12 PM, TÃ¶rÃ¶k Edwin <edwintorok@gmail.com> wrote:> Hi,>> Today's linux-next tree (commit> 93847083e4791567931bd17c039cc35881cdad29) fails to boot:> [built with gcc-4.2.4-3]>> BUG: Int 14: CR2 b0049dea>     EDI 00000082 ESI 00000000 EBP c059be88 ESP c059be5c>     EBX f000ec62 EDX 0000000e ECX c0595480 EAX f000ec62>     err 00000000 EIP c0181ca0  CS 00000060 flg 00010082> Stack:   00000040 c06a2ba0 000080d0 c0595480 c0000f19c c000f180 c0581120> c059bea8>         c02bf19b 00000000 00000080 c059beb8 c0000f194 c000f180 0000000a> c059beb8>         c03a1059 00000000 00000000 c059bed8 c05c4c7c  0009efff 00000000> c04f4df4
Hi,
One really simple way of getting some more info out of this is to takethe EIP value (here c0181ca0) and run it through addr2line:
    $ addr2line -e vmlinux -i c0181ca0
But you need to make sure that the bzImage/vmlinux you bootedcorresponds to the vmlinux you are running addr2line against.
This will tell you the source line which produced the page fault andwill probably give a good clue as to what went wrong.
Thanks for reporting :-)

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
