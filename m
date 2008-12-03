Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbYLCQDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbYLCQDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYLCQDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:03:39 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:65070 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbYLCQDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YV+4NDgSnrjEZBSEn8etxPG7CbG0jQm2kS+i/fIPNwDIL0zc1bvzq7VyMQPQ0Nt0eK
         iEyyehwCuHoKUZUzWbKaE6dFMnfyd6U1GXGlaPFMDRuiUXkRwLoPvEXWbArdZDtfq+lO
         bJeNQbIMmjXpmQ/cnWupXfBfofiToReeazZ7Y=
Message-ID: <c62985530812030803s30b76fc6t209dfbef958ba532@mail.gmail.com>
Date: Wed, 3 Dec 2008 17:03:36 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: Kernel Error Message: modprobe used greatest stack depth
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <804dabb00812030611k222606a6j24097fcdd93862d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00812030611k222606a6j24097fcdd93862d2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter.

2008/12/3 Peter Teoh <htmldeveloper@gmail.com>:
> In less than 6 hours since I turned on the machine I have been getting
> these message (spread over different times) in my dmesg:
>
> Machine A (AMD Athlon 4200, 3G RAM):
>
> khelper used greatest stack depth: 7484 bytes left
> modprobe used greatest stack depth: 7184 bytes left
> mknod used greatest stack depth: 6976 bytes left
> showconsole used greatest stack depth: 6904 bytes left
> modprobe used greatest stack depth: 5600 bytes left
> mysearch.pl used greatest stack depth: 5536 bytes left
> mysearch.pl used greatest stack depth: 5496 bytes left
> firefox-bin used greatest stack depth: 5484 bytes left
> totem-video-thu used greatest stack depth: 5324 bytes left
> thunderbird-bin used greatest stack depth: 4864 bytes left
>
> And another machine (intel, 3G RAM):
>
> [    0.123030] khelper used greatest stack depth: 2768 bytes left
> [    3.518510] insmod used greatest stack depth: 2148 bytes left
> [    6.203832] insmod used greatest stack depth: 1424 bytes left


This is the result of CONFIG_DEBUG_STACK_USAGE turned on.
When a process exits, kernel/exit.c:check_stack_usage() is called.


> Seemingly harmless, but when it hit firefox, the entire firefox will
> hang - and it does not respond to any keyboard/mouse input.   Since it
> has hit two of my machine simultaneously, I don't it should be
> ignored.



When firefox exits, this function is called... If you think that
check_stack_usage()
could be responsible of this hang, perhaps you can put a printk()
after its call to check it.
I don't know, it depends on when it happens.

>
> Can someone help me?
>
> a.   How do I probe further the cause of the error?
> b.   Seemingly repeatable ..... how to generate a BUG() stack trace at
> the point of error - recompiling really needed?
> c.   Kernel version 2.6.28-rc6, with FTRACE compiled option turned on.
>  HOw do I used FTRACE to de


You should first try to find a way to reproduce it..... When does it happen?
