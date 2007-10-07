Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbXJGQyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbXJGQyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 12:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbXJGQy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 12:54:27 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbXJGQy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 12:54:26 -0400
Date: Sun, 7 Oct 2007 18:54:25 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [PATCH 1/2] Colored kernel output (run3)
In-Reply-To: <20071007164452.GA30429@elte.hu>
Message-ID: <Pine.LNX.4.64.0710071849240.16301@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062147370.20637@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710062209390.20637@fbirervta.pbzchgretzou.qr>
 <20071007163824.GA30063@elte.hu> <20071007164452.GA30429@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7 2007 18:44, Ingo Molnar wrote:
>> This patch makes it possible to give kernel messages a selectable 
>> color. It can be chosen at compile time, overridden at boot time, and 
>> changed at run time.
>
>here's some (good) text footprint data:
>
>with the feature disabled (which is the default), the text size 
>difference with patch #1:
>
>  vmlinux:
>     text    data     bss     dec     hex filename
>  7732358 1157269  401408 9291035  8dc51b vmlinux.before
>  7732358 1157269  401408 9291035  8dc51b vmlinux.after
>

I already posted the numbers. But it seems like the archives
like lkml.org or marc.info did not archive them (but i've cc'ed plenty
so you did not miss it.). See below.

>i.e. no overhead. Text size difference with patch #2:
>
>  vmlinux:
>     text    data     bss     dec     hex filename
>  7732358 1157269  401408 9291035  8dc51b vmlinux.before
>  7732374 1157269  401408 9291051  8dc52b vmlinux.after
>
>16 bytes, or 0.0002% of the total text size. So there's in essence no 
>text overhead to talk about. So the text overhead argument is a red 
>herring.

16 bytes, huh? Can't be. That would be like, perhaps 5, x86 instructions.

||Date: Sat, 6 Oct 2007 22:09:13 +0200 (CEST)
||Subject: [PATCH 0/2] Colored kernel output (run3)
||
||ok, so to make Oleg happy, here is run3 with a bool config option.
||
||i386>>
|| 48679  vt.o w/o anything
|| 48679  vt.o w/patch1
|| 49117  vt.o w/patch1        + CONFIG_VT_CKO=y
|| 49198  vt.o w/patch1+patch2 + CONFIG_VT_CKO=y
||--------
||   519  total cost of CKO
||
||x86_64>>
|| 71892  vt.o w/patch1+patch2
|| 72787  vt.o w/patch1+patch2 + CONFIG_VT_CKO=y
||--------
||   895
