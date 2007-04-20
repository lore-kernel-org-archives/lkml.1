Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXDTLVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXDTLVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXDTLVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:21:30 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:39257 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753948AbXDTLV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:21:29 -0400
Message-ID: <4628A238.3010602@vmware.com>
Date: Fri, 20 Apr 2007 04:21:28 -0700
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Xavier Bestel <xavier.bestel@free.fr>, roland <devzero@web.de>,
       linux-kernel@vger.kernel.org
Subject: Re: VMWare Workstation 6 for debugging Linux Kernel (!)
References: <03f401c782d4$95c323e0$eeeea8c0@aldipc>	<1177058522.14404.132.camel@frg-rhel40-em64t-04> <p73r6qf49zc.fsf@bingen.suse.de>
In-Reply-To: <p73r6qf49zc.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Xavier Bestel <xavier.bestel@free.fr> writes:
> 
>> On Fri, 2007-04-20 at 00:46 +0200, roland wrote:
>>
>>> We just quietly added an exciting feature to Workstation 6.0. I believe it 
>>> will make WS6 a great tool for Linux kernel development. You can now debug 
>>> kernel of Linux VM with gdb running on the Host without changing anything in 
>>> the Guest VM. No kdb, no recompiling and no need for second machine. All you 
>>> need is a single line in VM's configuration file.
>> I think qemu has the exact same feature.
> 
> It doesn't seem to work for x86-64 there though.

Hello,

Do you mean with qemu or with VMware?  Yes, we do not support replay 
with 64bit guests, but debug interface should just work.  Only gotcha is 
that for 64bit guest you need another option:

debugStub.listen.guest64 = "TRUE"

and then you need to attach gdb to port 8864 (*).  Unfortunately it does 
not seem possible to build gdb which would support 16bit/32bit code 
while using 64bit gdb on-wire format, so there are two interfaces.  And 
if you single-step switch from 64bit mode to 32bit mode or back, you 
also have to switch gdbs.  Yes, it is a bit unintuitive, and 
additionally one gdb silently ignores breakpoints set up by other gdb, 
so you need to keep breakpoints in sync between two gdbs yourself :-(

(*) If you are using gdb which has both 32bit and 64bit support, be sure 
to issue appropriate 'set architecture xxx' before 'target remote 
localhost:88xx' (i386:x86-64 for port 8864, i386 or i8086 for port 
8832).  Otherwise gdb is going to die complaining it could not parse 
remote reply.

				Best regards,
					Petr Vandrovec

P.S.: Yes, I'm associated with VMware.
