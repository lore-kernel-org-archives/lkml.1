Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYD2GTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYD2GTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 02:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbYD2GSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 02:18:53 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:16507 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbYD2GSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 02:18:51 -0400
Message-ID: <4816BDAD.3000906@larces.uece.br>
Date: Tue, 29 Apr 2008 03:18:21 -0300
From: Sergio Luis <sergio@larces.uece.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Glauber Costa <gcosta@redhat.com>
CC: Ken Moffat <zarniwhoop@ntlworld.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25 slow boot/reboot
References: <48141111.7010605@larces.uece.br>	 <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>	 <20080427235554.GA28344@deepthought> <48152747.4030107@larces.uece.br>	 <4815DCEF.3000602@redhat.com> <430c4fa50804280735o3d1c3b9cg687f7d374dafbdec@mail.gmail.com> <48166CA1.1070000@redhat.com>
In-Reply-To: <48166CA1.1070000@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> Sergio Luis wrote:
>> On Mon, Apr 28, 2008 at 11:19 AM, Glauber Costa <gcosta@redhat.com>
>> wrote:
>>> Sergio Luis wrote:
>>>
>>>> Ken Moffat wrote:
>>>>
>>>>> On Sun, Apr 27, 2008 at 05:23:57PM +0200, Bart Van Assche wrote:
>>>>>
>>>>>> On Sun, Apr 27, 2008 at 7:37 AM, Sergio Luis <sergio@larces.uece.br>
>>> wrote:
>>>>>>>  This weekend I got some time and decided to try out 2.6.25, but its
>>> booting process was _really_ slow in my laptop[1]. With 'old'
>>> 2.6.24.5 my
>>> machine would take about 48 secs until it gave me the login prompt.
>>> And it
>>> would take about 22 seconds to reboot.
> 
> Sergio,
> 
> You said your system freezes. Does it happen after the last message you
> see on dmesg, or during the kernel start up? It would help me to rule
> out (or not), any issues in the cpu initialization process itself.
>
Hello Glauber,

the "freeze" happens during the kernel start up. It goes starting with delays in some points.
as I mentioned, when it prints "Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled"
it takes 90 seconds to print the next message. And then to reach that "serial" message it took already 20 seconds.
And it keeps on freezing at some other points too, after that. I also noticed the mouse cursor in the left bottom
is blinking in a very slow frequency, like every 6 seconds. It really disappears for a while, then returns and stay 
for another while and so on.

by the way, I messed up my git tree and I was wondering how could I have it back to the state it was when I started
testing this. this linus' commit was the last one, by then:

----

commit c3bf9bc243092c53946fd6d8ebd6dc2f4e572d48
Merge: e3505dd... c2b91e2...
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Apr 26 14:04:32 2008 -0700

    Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x8
6/linux-2.6-x86-bigbox-bootmem-v3
    
    * 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6
-x86-bigbox-bootmem-v3:
      x86_64/mm: check and print vmemmap allocation continuous
      x86_64: fix setup_node_bootmem to support big mem excluding with memmap
      x86_64: make reserve_bootmem_generic() use new reserve_bootmem()
      mm: allow reserve_bootmem() cross nodes
      mm: offset align in alloc_bootmem()
      mm: fix alloc_bootmem_core to use fast searching for all nodes
      mm: make mem_map allocation continuous

----

right now I am not able to reproduce the _exact_ problem I had when i created this thread, i.e. I can't boot anymore. I tested 2.6.25 and it didn't have any
problems, it booted normally, like my 2.6.24.5 did. Then I tried 2.6.25-git1 and it gave me the delay problem I wrote in this thread about, but then the system panics with
"Unable to mount root fs on unknown-block(8,5)". I tested with 2.6.25-git11 and 2.6.25-git12 and they also gave me problems, including
new ones. The long delay is still there and with git11/12, another panic, now a problem very similar to the one Ingo reported at
http://lkml.org/lkml/2008/4/27/309 (gonna give the patch there a try tomorrow, just found that thread).

 
> As for reboot, any suspicious message on your kernel log?
can't check it for now, as I can't boot anymore, but hopefully tomorrow I will be able to.


Follows my cpuinfo, in the hope it helps.
thanks,
-sergio

----

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 72
model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-60
stepping	: 2
cpu MHz		: 2000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 0
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
bogomips	: 4021.66
clflush size	: 64

processor	: 1
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 72
model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-60
stepping	: 2
cpu MHz		: 2000.000
cache size	: 512 KB
physical id	: 0
siblings	: 2
core id		: 1
cpu cores	: 2
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
bogomips	: 4018.24
clflush size	: 64


