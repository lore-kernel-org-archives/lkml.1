Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYD3BFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYD3BFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 21:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbYD3BFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 21:05:46 -0400
Received: from hs-out-0708.google.com ([64.233.178.242]:12573 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212AbYD3BFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 21:05:45 -0400
Message-ID: <4817C5C9.5030204@larces.uece.br>
Date: Tue, 29 Apr 2008 22:05:13 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Glauber Costa <gcosta@redhat.com>, Ken Moffat <zarniwhoop@ntlworld.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25 slow boot/reboot
References: <48141111.7010605@larces.uece.br> <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com> <20080427235554.GA28344@deepthought> <48152747.4030107@larces.uece.br> <4815DCEF.3000602@redhat.com> <430c4fa50804280735o3d1c3b9cg687f7d374dafbdec@mail.gmail.com> <48166CA1.1070000@redhat.com> <4816BDAD.3000906@larces.uece.br> <481713E3.1050007@redhat.com> <20080429142819.GF26461@elte.hu>
In-Reply-To: <20080429142819.GF26461@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Glauber Costa <gcosta@redhat.com> wrote:
> 
>> [    1.375711] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
>> sharing enabled
>> [    4.399907] floppy0: no floppy controllers found
>>
>> a 90-second delay is not what's happening, or at least, not what the 
>> kernel is seeing. So my bet would be something clock-related. Probably 
>> the system's clocksource is not running the time correctly, which is 
>> causing system events to be delayed. I fail to see, however, how does 
>> the patch you bisected to influences this. Ingo, do you have any idea?
> 
> the first thing to check, does latest x86.git work fine:
> 

nope, it doesn't work fine, but gives me the same issue (I had to apply 
the scsi patch in http://lkml.org/lkml/2008/4/27/309 in order to make 
it boot, though).

>   http://people.redhat.com/mingo/x86.git/README
> 
> ? We've got fixes queued up - in particular one could result in 'slow' 
> systems by virtue of denying an ioremap():
> 
>   Subject: revert: "x86: ioremap(), extend check to all RAM pages"
> 
> maybe the bisection went haywire.
> 

I tried re-bisecting using now 2.6.25 as my initial good kernel, but in 
the 2nd or 3r iteration I start having compilation problems like such as 

--
ld:fs:afs/cell.o: file format not recognized; treating as linker script
ld:fs/afs/cell.o:1: syntax error

The same problem happens with fs/autofs/inode.o and crypto/hmac.o
--

and it stopped the bisection process from going forward.


I am using binutils 2.17.50.0.17 (slackware 12 here) and also tried the
latest binutils cvs, but it gives me the same error there.

Any suggestions?
thanks,
-sergio

> Or the secondary core booted up in such a sucky way that it causes such 
> massive slowdowns? Perhaps we are flooding the system with local APIC 
> timer interrupts or other interrupts?
> 
> 	Ingo

