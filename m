Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbYIVNj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbYIVNj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:39:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYIVNjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:39:20 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:33391 "EHLO
	orion.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbYIVNjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:39:19 -0400
Message-ID: <48D79FFD.1060102@cateee.net>
Date: Mon, 22 Sep 2008 15:39:09 +0200
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Chris Li <lkml@chrisli.org>, Mauro Carvalho Chehab <mchehab@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
References: <s5hbpyny7bl.wl%tiwai@suse.de>	<20080918122541.2c3c7b39@areia.chehab.org>	<48D27734.3040600@cateee.net>	<alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>	<48D36D02.4090003@cateee.net>	<s5hy71oyviu.wl%tiwai@suse.de>	<70318cbf0809191655m89e4b4fo68c3693487afed98@mail.gmail.com> <s5hk5d4xzw0.wl%tiwai@suse.de>
In-Reply-To: <s5hk5d4xzw0.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai wrote:
> At Fri, 19 Sep 2008 16:55:51 -0700,
> Chris Li wrote:
> 
>> I avoid arch/ and firmware/ because it is nasty. I figure module in
>> arch/ is small enough I don't mind building it. And the firmware directory,
>> if I don't build the module loads it. Those firmware will automatically skipped
>> any way.
> 
> Agreed.
> 
>> The little tricky part is some thing like this:
>> ========================
>> ifeq ($(CONFIG_BLK_DEV_CMD640), m)
>>         obj-m += cmd640.o
>> endif
>> ========================
>> Internally it get convert it into:
>> "obj-$(CONFIG_BLK_DEV_CMD640) += cmd640.o"

Are you sure?
I.e. if you set CONFIG_BLK_DEV_CMD640=y, you see that
the two constructs gives different results.

If the makefile author did such complex construct, I
really think there is a reason ;-)

ciao
	cate


> 
> This should be fixed in Makefile.
> Care to submit a patch?
> 
> 
> Takashi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

