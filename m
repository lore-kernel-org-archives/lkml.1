Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYD2Md0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYD2Md0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbYD2MdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:33:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbYD2MdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:33:17 -0400
Message-ID: <481713E3.1050007@redhat.com>
Date: Tue, 29 Apr 2008 09:26:11 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sergio Luis <sergio@larces.uece.br>
CC: Ken Moffat <zarniwhoop@ntlworld.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25 slow boot/reboot
References: <48141111.7010605@larces.uece.br>	 <e2e108260804270823t45611ec2t35da085833d82dfa@mail.gmail.com>	 <20080427235554.GA28344@deepthought> <48152747.4030107@larces.uece.br>	 <4815DCEF.3000602@redhat.com> <430c4fa50804280735o3d1c3b9cg687f7d374dafbdec@mail.gmail.com> <48166CA1.1070000@redhat.com> <4816BDAD.3000906@larces.uece.br>
In-Reply-To: <4816BDAD.3000906@larces.uece.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergio Luis wrote:
> Glauber Costa wrote:
>> Sergio Luis wrote:
>>> On Mon, Apr 28, 2008 at 11:19 AM, Glauber Costa <gcosta@redhat.com>
>>> wrote:
>>>> Sergio Luis wrote:
>>>>
>>>>> Ken Moffat wrote:
>>>>>
>>>>>> On Sun, Apr 27, 2008 at 05:23:57PM +0200, Bart Van Assche wrote:
>>>>>>
>>>>>>> On Sun, Apr 27, 2008 at 7:37 AM, Sergio Luis <sergio@larces.uece.br>
>>>> wrote:
>>>>>>>>  This weekend I got some time and decided to try out 2.6.25, but its
>>>> booting process was _really_ slow in my laptop[1]. With 'old'
>>>> 2.6.24.5 my
>>>> machine would take about 48 secs until it gave me the login prompt.
>>>> And it
>>>> would take about 22 seconds to reboot.
>> Sergio,
>>
>> You said your system freezes. Does it happen after the last message you
>> see on dmesg, or during the kernel start up? It would help me to rule
>> out (or not), any issues in the cpu initialization process itself.
>>
> Hello Glauber,
> 
> the "freeze" happens during the kernel start up. It goes starting with delays in some points.
> as I mentioned, when it prints "Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled"
> it takes 90 seconds to print the next message. And then to reach that "serial" message it took already 20 seconds.
> And it keeps on freezing at some other points too, after that. I also noticed the mouse cursor in the left bottom
> is blinking in a very slow frequency, like every 6 seconds. It really disappears for a while, then returns and stay 
> for another while and so on.
This does not correspond, by far, to what is seen in the dmesg you posted.

[    1.375711] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ 
sharing enabled
[    4.399907] floppy0: no floppy controllers found

a 90-second delay is not what's happening, or at least, not what the 
kernel is seeing. So my bet would
be something clock-related. Probably the system's clocksource is not 
running the time correctly, which is causing system events to be 
delayed. I fail to see, however, how does the patch you bisected to 
influences this. Ingo, do you have any idea?

> by the way, I messed up my git tree and I was wondering how could I have it back to the state it was when I started
> testing this. this linus' commit was the last one, by then:
> 
> ----
> 
> commit c3bf9bc243092c53946fd6d8ebd6dc2f4e572d48
git-reset --hard c3bf9bc243092c53946fd6d8ebd6dc2f4e572d48

> 
> right now I am not able to reproduce the _exact_ problem I had when i created this thread, i.e. I can't boot anymore. I tested 2.6.25 and it didn't have any
> problems, it booted normally, like my 2.6.24.5 did. 

So maybe the commit you bisected too is not really guilty. If you can 
now boot 2.6.25 fine, it might be the case that the commits you marked 
as good in the bisection process were not really good.

> 
> ----
> 
> processor	: 0
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 72
> model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-60
> stepping	: 2
> cpu MHz		: 2000.000
> cache size	: 512 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 2
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
> bogomips	: 4021.66
> clflush size	: 64
> 
> processor	: 1
> vendor_id	: AuthenticAMD
> cpu family	: 15
> model		: 72
> model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-60
> stepping	: 2
> cpu MHz		: 2000.000
> cache size	: 512 KB
> physical id	: 0
> siblings	: 2
> core id		: 1
> cpu cores	: 2
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 1
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm 3dnowext 3dnow pni cx16 lahf_lm cmp_legacy svm extapic cr8_legacy ts fid vid ttp tm stc
> bogomips	: 4018.24
> clflush size	: 64
> 
> 

