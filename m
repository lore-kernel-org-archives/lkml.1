Return-Path: <linux-kernel-owner+w=401wt.eu-S933244AbZHVGM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244AbZHVGM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 02:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbZHVGM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 02:12:28 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:54297 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933210AbZHVGM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 02:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vr56nxl2oAxNSGHDefvwGVX3dKnluZtdJAARjdadmKFUtvKsLvIRzjyJDFhgWBPoJ1
         +7+7wlD3WiEjGYYGBhPBxKOiwuXUJAO9rCDo8XLFVTl1yq8hiSSohFp37TiYzts1nSqq
         gPh/3bd7FQB7CM6j2BUcrz/YOlovS5+kT9z3w=
Message-ID: <4A8F8C49.2030406@gmail.com>
Date: Sat, 22 Aug 2009 00:12:25 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@verizon.net>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Linux 2.6.31-rc7 lost sensors on asus mobo
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain> <200908212309.31505.gene.heskett@verizon.net>
In-Reply-To: <200908212309.31505.gene.heskett@verizon.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2009 09:09 PM, Gene Heskett wrote:
> On Friday 21 August 2009, Linus Torvalds wrote:
>> You know the drill, so all together now: "Another week, another -rc
>> kernel".
>
> Another rebuild didn't help:
>
> Thinking it didn't load it87, I tried again:
>
> [root@coyote 3.002005]# modprobe it87
> FATAL: Error inserting it87 (/lib/modules/2.6.31-rc7/kernel/drivers/hwmon/it87.ko): Device or resource busy
> [root@coyote 3.002005]# sensors
> No sensors found!
> Make sure you loaded all the kernel drivers you need.
> Try sensors-detect to find out which these are.
>
> Been there, done that, no joy.
>
>  From messages when I attempt to access the it87:
> Aug 21 22:59:37 coyote kernel: [  572.507928] it87: Found IT8716F chip at 0x290, revision 1
> Aug 21 22:59:37 coyote kernel: [  572.507937] it87: in3 is VCC (+5V)
> Aug 21 22:59:37 coyote kernel: [  572.507939] it87: in7 is VCCH (+5V Stand-By)
> Aug 21 22:59:37 coyote kernel: [  572.508232] ACPI: I/O resource it87 [0x295-0x296] conflicts with ACPI region IP__ [0x295-0x296]
> Aug 21 22:59:37 coyote kernel: [  572.508234] ACPI: Device needs an ACPI driver
>
>  From uname -a
> Linux coyote.coyote.den 2.6.31-rc7 #2 SMP PREEMPT Fri Aug 21 22:37:38 EDT 2009 i686 athlon i386 GNU/Linux
>
> .config is attached, in case I've screwed the moose.
>

The ACPI AML on your machine indicates that the BIOS may attempt to 
access the it87 hardware, and the kernel now by default blocks it87 from 
requesting those ports as it may conflict with what the BIOS is trying 
to do. On some machines, the ACPI BIOS accesses hardware monitoring 
chips itself to manage ACPI thermal zones, etc. and the conflicting 
access can cause incorrect temperature readings and other bad behavior.

You can try acpi_enforce_resources=lax on the kernel command line to 
restore the previous behavior. Or for some Asus boards, you can try the 
asus_atk0110 ACPI driver instead of it87.
