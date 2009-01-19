Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbZASWhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbZASWhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 17:37:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZASWhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 17:37:43 -0500
Received: from h155.mvista.com ([63.81.120.155]:64868 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751812AbZASWhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 17:37:42 -0500
Message-ID: <497500AC.3040406@ru.mvista.com>
Date: Tue, 20 Jan 2009 01:37:32 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ide: move SFF I/O code to ide-io-sff.c
References: <20090119130309.24745.40877.sendpatchset@localhost.localdomain>	<20090119130322.24745.76137.sendpatchset@localhost.localdomain>	<49748B95.9080105@ru.mvista.com>	<200901191523.15240.bzolnier@gmail.com>	<49748E43.4030009@ru.mvista.com>	<20090119173701.13fd24c6@lxorguk.ukuu.org.uk>	<4974C030.5020509@ru.mvista.com>	<20090119183607.5ee804e1@lxorguk.ukuu.org.uk>	<4974CA81.1050506@ru.mvista.com>	<20090119184951.35a52184@lxorguk.ukuu.org.uk>	<4974CEC5.9050402@ru.mvista.com> <20090119213101.798fe1cd@lxorguk.ukuu.org.uk> <4974F515.4030304@ru.mvista.com>
In-Reply-To: <4974F515.4030304@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>>>> I'm afraid you are the one who is wrong. The IDE layer is 
>>>> duplicating a
>>>> generic level of indirection with its own code - purely because IDE
>>>> pre-dates that core functionality. The whole IDE layer indirection 
>>>> can go
>>>> away because Linux has caught up with the needs of the IDE layer.
>>>>       
>>>     What IDE indirection you're talking about anyway?
>>>     
>>
>> As I said earlier ide_mm_inb etc via the function pointers 
>> tf_inb/tf_outb
>> etc.
>>   
>
>   Ah... at least they don't have additional address checks that 
> ioread*()/iowrite*() have...

   Somehow I was looling at __ide_mm_{ins|outs}*() calls in ide-iops.c 
instead... it doesn't help to fix the USB code and argue about IDE at 
the same time. :-]

>> into two different versions of the functions like ide_tf_read as surely
>> it costs more to call them (in size) than to inline the two for those
>> functions?
>>   
> Given how small those functions are it might even be worth rolling them
>
>   Indeed.

  The calling fucntions aren't that small, so it's again arguable...

MBR, Sergei


