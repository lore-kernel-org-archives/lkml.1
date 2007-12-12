Return-Path: <linux-kernel-owner+w=401wt.eu-S1757206AbXLLCIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206AbXLLCIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 21:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXLLCH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 21:07:56 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:60561 "EHLO
	home.nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXLLCH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 21:07:56 -0500
Message-ID: <475F4273.80905@nigel.suspend2.net>
Date: Wed, 12 Dec 2007 13:07:47 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
References: <475F1DC6.5090403@keyaccess.nl> <475F2358.6060006@nigel.suspend2.net> <475F24C1.2050807@keyaccess.nl>
In-Reply-To: <475F24C1.2050807@keyaccess.nl>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 12-12-07 00:55, Nigel Cunningham wrote:
> 
>> (AMD 1.8GHz Turion, running at 800MHz. ATI RS480 - Mitac 8350 mobo)
>>
>> nigel@home:~/Downloads$ gcc port80.c -o port80
>> nigel@home:~/Downloads$ sudo ./port80
>> cycles: out 1235, in 1207
> 
> Looking good.
> 
>> nigel@home:~/Downloads$ gcc -O2 port80.c -o port80
>> nigel@home:~/Downloads$ sudo ./port80
>> cycles: out 1844674407370794, in 1844674407369408
> 
> Obviously not. I suppose this changes with -m32 on the GCC command line?
> (sorry for missing that, I have no 64-bit machines).

Yes, it does:

nigel@home:~/Downloads$ gcc -m32 -o port80 port80.c
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1231, in 1208
nigel@home:~/Downloads$ sudo ./port80
cycles: out 1233, in 1210

Incidentally:

nigel@home:~/Downloads$ processor_speed

(A little script I made because my lappy does a solid lock every now and
then that seems to be cpu-freq related - locking it to one frequency
makes the lock far less common).

Speed is now 1800000.
nigel@home:~/Downloads$ sudo ./port80
cycles: out 2472, in 2505
nigel@home:~/Downloads$ sudo ./port80
cycles: out 2489, in 2515
nigel@home:~/Downloads$ sudo ./port80
cycles: out 2481, in 2503
nigel@home:~/Downloads$ sudo ./port80
cycles: out 2476, in 2507

So the same effect Maxim reported is seen here.

Regards,

Nigel
