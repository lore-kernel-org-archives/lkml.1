Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbYIQOVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbYIQOVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 10:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYIQOU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 10:20:56 -0400
Received: from mailer1.option.com ([81.246.70.162]:57746 "EHLO
	mailer1.option.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYIQOU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 10:20:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AocBAGSv0EgKAAAZ/2dsb2JhbAAIuGqBZw
Message-ID: <48D1122F.6080101@option.com>
Date: Wed, 17 Sep 2008 16:20:31 +0200
From: Denis Joseph Barrow <D.Barow@option.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "Amit S. Kale" <amitkale@linsyssoft.com>,
       Tom Rini <trini@kernel.crashing.org>, David Grothe <dave@gcom.com>,
       Tigran Aivazian <tigran@sco.com>, linux-kernel@vger.kernel.org
Subject: Re: getting false SIGTRAP breakpoints in kernel i.e. kernel hung
 unless gdb remotely attached on x86 & cont is issued
References: <48D10A70.8050202@option.com> <48D10C43.90605@windriver.com>
In-Reply-To: <48D10C43.90605@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2008 14:20:31.0137 (UTC) FILETIME=[8A6C0910:01C918D0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,
The problem I believe is very reproducable.
I'm doing nothing special with kgdb just using it to help me with 
3g modem driver development & my driver wasn't loaded when the problem occured.
I have the following command in my /boot/grub/menu.lst kernel parameter to enable gdb.
kgdboc=/dev/ttyS0,115200 maxcpus=1

And when I do the steps mentioned when in a console I get a message waiting for gdb to attach
I'm familiar with kgdb, have been using it for years & know enough to be sure this is undesired behaviour.

Jason Wessel wrote:
> Denis Joseph Barrow wrote:
>> Hi ladies/gentlemen,
>> The kernel I'm running gdb with is 2.6.27-rc4
>> The false sigtrap is occuring in ia32_sysenter_target in arch/x86/kernel/entry_32.S:303
>> when gdb is stepped from the user process as described below
>>
>>   
> 
> Your example does not indicate how or why you setup kgdb.  kgdb can be
> compiled into the kernel, but it should not have any effect what so ever
> unless it is configured for use because it will not register to receive
> any of the breakpoint or single stepping traps.
> 
> Perhaps there is more to the description of your problem?
> 
> Jason.
> 
>> To reproduce
>> compile kernel with kgdb support 
>> compile my randsleep program attached using the .mk script
>> as root
>> attach randsleep to an idle serial port e.g. /dev/ttyS0 by typing
>> randsleep /dev/ttyS0
>> from another bash shell type
>> ps -aux | grep randsleep
>>
>> gdb ./randsleep
>> attach <pid of randsleep>
>>
>> You should get messages from gdb like
>> Attaching to program: /home/djbarrow/devel2/randsleep/randsleep, process 6397
>> Reading symbols from /lib/tls/i686/cmov/libc.so.6...done.
>> Loaded symbols for /lib/tls/i686/cmov/libc.so.6
>> Reading symbols from /lib/ld-linux.so.2...done.
>> Loaded symbols for /lib/ld-linux.so.2
>> 0xb7fda430 in __kernel_vsyscall ()
>>
>> Now type step.
>>
>> The machine is now hung until gdb attaches remotely.
>>
>>
>>   


-- 
best regards,
D.J. Barrow
