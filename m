Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbYENWn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbYENWn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754173AbYENWns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:43:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:47671 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYENWnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:43:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LnP3eqH49ln0aL9yq6fDSecWSdbtYOw77Z784VuhgNJhhBr9rgRz5GkOOAaadnOjdYcERcFy3WmyDfnDvWFED7Bju5yANfXg5aX/T5NXMrvjGUFg2+rbSgSPm3ZcMF9qDAvnou50gZlllbLhkmQ3pmyVsFdXDQ0BFh15F1HnAX4=
Message-ID: <2c0942db0805141543n20e6eb6eq5fe13fe1cb50d67e@mail.gmail.com>
Date: Wed, 14 May 2008 15:43:46 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Lee Howard" <faxguy@howardsilvan.com>
Subject: Re: troubleshooting/debugging hard locks
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <482B3D21.5020903@howardsilvan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <482B3D21.5020903@howardsilvan.com>
X-Google-Sender-Auth: 40b6a7cefc906ac4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m4EMi1EB021806

On Wed, May 14, 2008 at 12:27 PM, Lee Howard <faxguy@howardsilvan.com> wrote:> (Please reply also directly to my e-mail address since I am not subscribed> to the list.)>>  Hello,>>  I am using Fedora 9 (and have been for the last few weeks of the "preview"> period... constantly updating if possible) and testing for a fax server> using Mainpine IQ Express (PCIe) multi-modem fax cards (they use the 8250> serial driver).>>  My testing involves queuing up and sending 2000 fax jobs using HylaFAX+> 5.2.4 to send out on two ports (1000 jobs on each port) of a 4-port card -> receiving those calls on the other two ports.>>  This exact hardware works perfectly fine with similar testing in Windows XP> Pro SP2.  However, usually on Fedora 9 (and even occasionally on Fedora 8)> the system will lock up hard (i.e. the Numlock key does not light up the LED> on the keyboard and SysReq keys do nothing) somewhere during the process.> This happens infrequently when the OS is Fedora 8 and usually (but not> always) when using Fedora 9.>>  There are no kernel messages on the monitor.  I've set up a remote serial> console on ttyS0, and there are usually no messages there, either, when this> happens.  Twice I did get messages that looked like a lot of this:>>  CPU1: Temperature above threshold, cpu clock throttled (total events = 1)>  CPU0: Temperature/speed normal>  CPU1: Temperature above threshold, cpu clock throttled (total events = 275)>  CPU0: Temperature/speed normal>  CPU1: Temperature above threshold, cpu clock throttled (total events = 577)>  CPU0: Temperature/speed normal>  CPU1: Temperature above threshold, cpu clock throttled (total events = 696)>  CPU0: Temperature/speed normal>>  ... but there was nothing more.  The side of the system chassis is removed,> the fans are moving, and the hard lock still occurs even if I point a large> fan at the open system and prevent the temperature warnings from occurring.> I've used sensors to monitor the temperature during the test with the> external fan pointed at the open system, and the temperatures stay roughly> as this:>>  [root@localhost ~]# sensors>  it8718-isa-0290>  Adapter: ISA adapter>  in0:         +1.23 V  (min =  +0.00 V, max =  +4.08 V)  in1:         +1.82> V  (min =  +0.00 V, max =  +4.08 V)  in2:         +3.26 V  (min =  +0.00 V,> max =  +4.08 V)  in3:         +2.94 V  (min =  +0.00 V, max =  +4.08 V)> in4:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM>  in5:         +0.00 V  (min =  +0.00 V, max =  +4.08 V)   ALARM>  in6:         +1.28 V  (min =  +0.00 V, max =  +4.08 V)  in7:         +3.07> V  (min =  +0.00 V, max =  +4.08 V)  in8:         +3.28 V>  fan1:        688 RPM  (min =    0 RPM)>  fan2:          0 RPM  (min =    0 RPM)>  fan3:          0 RPM  (min =    0 RPM)>  temp1:       +37.0Â°C  (low  = +127.0Â°C, high = +127.0Â°C)  sensor => transistor>  temp2:       +30.0Â°C  (low  = +127.0Â°C, high = +127.0Â°C)  sensor = thermal> diode>  temp3:        -2.0Â°C  (low  = +127.0Â°C, high = +127.0Â°C)  sensor => transistor>  cpu0_vid:   +1.063 V>>  So I tend to think that the temperature warnings are a result of a looming> hard-lock or they're simply a red herring.>>  But, without kernel messages indicating where to look to debug... what is> the best approach to start troubleshooting and debugging this condition?  Is> there some general debug feature that can be enabled in the kernel that> would help hone in on the culprit?
There's something called the NMI watchdog, that will print debuggingmessages out if it finds the system has hard locked. The short versionis that you should add "nmi_watchdog=1" (no quotes) to the line inGRUB that has the kernel options. That assumes you have an APIC on thesystem. If that's not the case (you're on Uniprocessor, and no APIC)then you can try nmi_watchdog=2 instead. That'll only work on somesystems, though.
Better docs (than my cheesy writeup) are inDocumentation/nmi_watchdog.txt in the kernel source distribution.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
