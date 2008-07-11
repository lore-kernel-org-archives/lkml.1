Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbYGKPAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbYGKPAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYGKPAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:00:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:45157 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYGKPAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wrehDER0SbEbTpt7GnIMje5oVp/7OX0RzuFbd4Lki8OOIlgqOkfc52AuKP6hhDUKJB
         Zg5RxzI0HVgg0fjg2yRxhW+c8rgxsI48VBHbju7fWx5DIAGXgOCTTwT4C7s1DQXcpz5e
         N45kb1vMt3LPV+VWJP+r5RrgC24hSEuN/cnjU=
Message-ID: <19f34abd0807110800o5b283f00n4be7449ed3b06e5a@mail.gmail.com>
Date: Fri, 11 Jul 2008 17:00:42 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "=?UTF-8?Q?T=C3=B6r=C3=B6k_Edwin?=" <edwintorok@gmail.com>
Subject: Re: today's linux-next fails to boot
Cc: "Ingo Molnar" <mingo@elte.hu>, "Takashi Iwai" <tiwai@suse.de>,
       linux-next@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0807110754n1a095671ua9132471b6a81540@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <4877400B.1000400@gmail.com> <s5hy747rvpr.wl%tiwai@suse.de>
	 <48775C69.6050107@gmail.com> <20080711135937.GA25004@elte.hu>
	 <487772B6.4090100@gmail.com>
	 <19f34abd0807110754n1a095671ua9132471b6a81540@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6BF0vfq025947

> On Fri, Jul 11, 2008 at 4:48 PM, TÃ¶rÃ¶k Edwin <edwintorok@gmail.com> wrote:>>> One really simple way of getting some more info out of this is to take>>> the EIP value (here c0181ca0) and run it through addr2line:>>>>>>     $ addr2line -e vmlinux -i c0181ca0>>>> Thanks for the hint, I rebuilt a failing kernel, and this is what>> addr2line says:>>>> $ addr2line -e vmlinux -i c0181ca0>>>> ??:0>> $ addr2line -e vmlinux -f c0181ca0>> kmem_cache_alloc>> ??:0
BTW, did the new kernel fail in exactly the same place? If not, youshould also replace the EIP in the new crash report on the addr2linecommand line, so in general: addr2line -e vmlinux -f -i <EIP here>.
(I don't think it really makes sense for the kernel to crash inkmem_cache_alloc() this early in the boot process, so I'm guessing youhave a different EIP.)
(Also don't rebuild a bad kernel just to try this out again, but ifyou happen to run across another bad one for example during bisection,you can try it then.)

Vegard
-- "The animistic metaphor of the bug that maliciously sneaked in whilethe programmer was not looking is intellectually dishonest as itdisguises that the error is the programmer's own creation."	-- E. W. Dijkstra, EWD1036ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
