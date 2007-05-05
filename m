Return-Path: <linux-kernel-owner+w=401wt.eu-S933219AbXEET7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933219AbXEET7N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 15:59:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933235AbXEET7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 15:59:13 -0400
Received: from smtp35.poczta.interia.pl ([80.48.65.35]:4522 "EHLO
	smtp4.poczta.interia.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933219AbXEET7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 15:59:11 -0400
Message-ID: <463CE1FB.4050305@interia.pl>
Date: Sat, 05 May 2007 21:58:51 +0200
From: =?ISO-8859-2?Q?Rafa=B3_Bilski?= <rafalbilski@interia.pl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070321)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Wander Winkelhorst <w.winkelhorst@gmail.com>,
       David Johnson <dj@david-web.co.uk>, linux-kernel@vger.kernel.org,
       cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>  <200705042320.41278.dj@david-web.co.uk>  <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>  <463C18C4.7030304@interia.pl> <5699f8f00705050144s5c00a455s8f7dba9258d83986@mail.gmail.com> <463CC380.3060603@interia.pl> <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705052028560.18504@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
X-EMID: 1ad2eacc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> I found one line which wasn't were it should be. Probably this will not 
>> fix Your problem with powersave governor, but it is a bit related. 
>> Looks like Longhaul isn't skipping frequency transtition when it is asked 
>> to set f which is already set. Now after first transition it will not 
>> try to set same frequency again. Second part contains some magic 
>> because I don't have CN400 datasheet. It is NDA protected :-( Should 
>> print You one byte in hex and will try to set one register. I don't 
>> know if anything will change but it is worth testing.
> 
> Did not help unfortunately. The output the printk line generated was
>   longhaul: 0x0
> 
> (Strangely enough, %#02x with glibc outputs "00", not "0x0".
> And I would have expected "0x00". Subtleties of the kernel 
> printk/glibc?)
:-/ Weird. Nothing new in datasheet. Longhaul MSR seems to be OK too. 
Would be good to check if PLL really can go downto x4,0. Can You 
limit minimal CPU multiplier to 5,0 and check if is stable? If it 
is check 4,5.
Please send me below part of Your dmesg too:
CPU: After generic identify, caps: 0381b83f 00000000 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (32 bytes/line), D cache 64K (32 bytes/line)
CPU: L2 Cache: 64K (32 bytes/line)
CPU: After all inits, caps: 0381b93f 00000000 00000000 00000000 00000000 000000dd 00000000

"dd" is very important here.
> Jan
Rafa³



----------------------------------------------------------------------
Kasia Cichopek eksponuje biust  
>>> http://link.interia.pl/f1a6f

