Return-Path: <linux-kernel-owner+w=401wt.eu-S1758098AbYB2SNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758098AbYB2SNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYB2SN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:13:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:39254 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750790AbYB2SN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:13:26 -0500
X-Authenticated: #4463548
X-Provags-ID: V01U2FsdGVkX18bR+0c804bPwnjjVUs3DzUOm9ns3lxT8r3oygyi+
	t6XpS+LMXkPHnJ
Message-ID: <47C84B40.6000501@gmx.net>
Date: Fri, 29 Feb 2008 20:13:20 +0200
From: Dimitrios Apostolou <jimis@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.10) Gecko/20070301 SeaMonkey/1.0.8
MIME-Version: 1.0
To: Bernd Petrovitsch <bernd@firmix.at>
CC: linux-kernel@vger.kernel.org
Subject: Re: swap file over jffs2 partition
References: <47C772E9.2000000@gmx.net> <1204276763.18969.10.camel@tara.firmix.at>
In-Reply-To: <1204276763.18969.10.camel@tara.firmix.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bernd Petrovitsch wrote:
> On Fre, 2008-02-29 at 04:50 +0200, Dimitrios Apostolou wrote:
>> Hello list,
>>
>> I intend to build a diskless linux system (root over NFS). Because it
>> has 1GB of embedded flash storage, I'm thinking of using this as swap 
>> (I've been bitten many times by the problems linux has with *no* 
> 
> Put more RAM on the hardware and/or reduce the software on it.
> If that means heavily customizing the distribution: Do it.
> If that means you can't run some specific common distribution[0]: Throw
> it out and roll your own minimalistic one with just the tools and
> especially libraries you need.
> We run Linux on embedded hardware all the time without swapspace without
> any problems (related to the "missing" swapspace).

I have been running swapless linux systems a long time ago, but I think 
I have had more problems than not. I have tried setting swappiness and 
overcommit settings but these don't help much. Let me explain:

When it is not certain that your system will run a specific task and 
only that, it is almost certain that sometime you will run out of 
memory. For example in the thin client case a user might open too many 
windows and fill the RAM with X server pixmaps...

So when the out of memory condition happens the system will start 
swapping. And if you have no swap enabled, the system will swap even 
harder: it will swap out all mmap'ed read-only memory segments, which 
mostly are the executables themselves. And because these will be needed 
immediately they will be swapped in immediately afterwards...

This renders the system *unusable* for all cases. Sometimes it even 
stops responding to ping... On the other hand if you have a swap 
partition then the kernel will choose to swap out other memory segments, 
not the executable ones that are so much needed.

> 
>> swap...). And to avoid wearing out the flash storage too fast, I 'm 
> 
> Swapping (and constantly writing logfiles) will wear it out much faster
> than without. Perhaps not at development time but for sure in the field.

That's why I want to do it over a wear-levelling layer. Given that the 
partition is large enough it will hopefully take a while to wear it out.


Thanks,
Dimitris

> 
> [....]
> 
> 	Bernd
> 
> [0]: Which I highly doubt.

