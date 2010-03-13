Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab0CMIv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:51:56 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57702 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab0CMIvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ele1tlLmg6mF3BB3izhV4J1zE1k7i6FlE8KsdBlGijp5el9vqfKsi6wvXTcPzRIwLX
         4CX+f6GrjV22aHX0fnp2HsLG0JouHRs3Ek+0eScMp47CiBNCtAriHpPuet93NHBL9Pdk
         HgDQperxZdfOlp7A5F4OGLb9kvKBDRCVjq7+A=
Message-ID: <4B9B51BF.2070201@gmail.com>
Date: Sat, 13 Mar 2010 09:50:07 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yuasa Yoichi <yuasa@linux-mips.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>, jamie@shareable.org
Subject: Re: [PATCH v2] char drivers: Ram oops/panic logger
References: <4B968834.3040609@gmail.com>	<21eaeb5a1003091808s2d7638cxd524952a7d84b378@mail.gmail.com>	<2ea1731b1003100002w104633ffy1ae46ef3d245e5b5@mail.gmail.com>	<21eaeb5a1003100120x6cd3f69ak598954af3c9fe955@mail.gmail.com>	<2ea1731b1003100415i46dd8fcem85b85f49fb1a479@mail.gmail.com> <20100312144854.cb94d9b4.akpm@linux-foundation.org>
In-Reply-To: <20100312144854.cb94d9b4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 12/03/2010 23:48, Andrew Morton ha scritto:
> On Wed, 10 Mar 2010 13:15:25 +0100
> Marco Stornelli <marco.stornelli@gmail.com> wrote:
> 
>> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
>>> 2010/3/10 Marco Stornelli <marco.stornelli@gmail.com>:
>>>> 2010/3/10 Yuasa Yoichi <yuasa@linux-mips.org>:
>> I meant with the "classic" use of mtdoops, therefore with a flash
>> partition without use MTD_RAM. Using MTD_RAM, it's more or less the
>> same thing, with the exception of "where" you want deploy the log. For
>> example: if in your system you have got a nvram you can use it without
>> problem, you need to specify the address of the nvram to the module.
>> Very simple. I  think it's a small driver but very useful, feedback
>> from other embedded guys are welcome.
> 
> Seems sensible to me.  If you have a machine whose memory is persistent
> across reboots then you reserve an arbitrary 4k hunk of memory for
> collecting oops traces, yes?

Yes.

> 
> What tools are used for displaying that memory on the next boot?  How
> do those tools distinguish between "valid oops trace" and "garbage
> because it was just powered on"?  A magic signature?

For my test I used the program devmem2 to dump the log. In general, you
can read the memory via /dev/mem. There's an header plus a timestamp of
the log. The memory is initialized with blank spaces and the size of the
record is fixed at 4k, so if a program/script doesn't find the header at
next 4k, it means there's garbage and it can stop the read operation.

> 
> Should the kernel provide the 4k of memory rather than (or in addition
> to) requiring that the system administrator reserve it and tell the
> kernel about it?  That'd be a matter of creating a linker section which
> isn't cleared out by the startup code.
> 
> 

Yes, it can be an option. My first idea was to write a "general" driver,
with an address in input that it can be related to the reserved RAM as
an NVRAM in the system, however it can be a good idea, why not.

Marco
