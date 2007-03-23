Return-Path: <linux-kernel-owner+w=401wt.eu-S1422673AbXCWIXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422673AbXCWIXs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 04:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422696AbXCWIXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 04:23:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:53874 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422673AbXCWIXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 04:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ROHTb0nIqjziPzRf4/+EcPY7j6ERWzdA5Wby8+q70hoarpNjagxxNeEh/U4fug0LXaBAv7acMWHQnCD13PYyQo8a7p36P5ku4Z7Xj0sz4MNacIyG/eZrmpJMj3TkArHXKe8LGrAZL7BcPo555KtCCzdxWnm2KL+RRyqZrLCHxGs=
Message-ID: <46038E68.4070807@googlemail.com>
Date: Fri, 23 Mar 2007 09:23:04 +0100
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: vgoyal@in.ibm.com
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-rt0-kdump
References: <6bffcb0e0703211338i2aa6f933ube53c6604c78e285@mail.gmail.com> <20070322093119.GA19394@elte.hu> <6bffcb0e0703220557h7ff64282qf378623452c07d03@mail.gmail.com> <4602843D.9000306@googlemail.com> <20070323052501.GA1421@in.ibm.com>
In-Reply-To: <20070323052501.GA1421@in.ibm.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal napisał(a):
> On Thu, Mar 22, 2007 at 02:27:25PM +0100, Michal Piotrowski wrote:
>> Michal Piotrowski napisał(a):
>>> On 22/03/07, Ingo Molnar <mingo@elte.hu> wrote:
>>>> * Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
>>>>
>>>>> Hi Ingo,
>>>>> 2.6.21-rc4-rt0
>>>>> BUG: at kernel/fork.c:1033 copy_process()
>>>> thanks Michal - this is a real bug that affects upstream too. Find the
>>>> fix below - i've test-booted it and it fixes the warning.
>>> Problem is fixed, thanks.
>> BTW. It seems that nobody uses -rt as a crash dump kernel ;)
>>
>> BUG: unable to handle kernel paging request at virtual address f7ebf8c4
>>  printing eip:
>> c1610192
>> *pde = 00000000
>> stopped custom tracer.
>> Oops: 0000 [#1]
>> PREEMPT 
>> Modules linked in:
>> CPU:    0
>> EIP:    0060:[<c1610192>]    Not tainted VLI
>> EFLAGS: 00010206   (2.6.21-rc4-rt0-kdump #3)
>> EIP is at copy_oldmem_page+0x4a/0xd0
>> eax: 000008c4   ebx: f7ebf000   ecx: 00000100   edx: 00000246
>> esi: f7ebf8c4   edi: c4c520fc   ebp: c4d54e30   esp: c4d54e18
>> ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068  preempt:00000001
>> Process swapper (pid: 1, ti=c4d54000 task=c4d52c20 task.ti=c4d54000)
>> Stack: c17ab7e0 c183f982 c1969658 00000400 00000400 00037ebf c4d54e5c c16af187 
>>        00037ebf c4c520fc 00000400 000008c4 00000000 00000000 c4c696e0 00000400 
>>        c4c520fc c4d54f94 c19a9cfd c4c520fc 00000400 c4d54f78 00000000 c1840996 
>> Call Trace:
>>  [<c16af187>] read_from_oldmem+0x73/0x98
>>  [<c19a9cfd>] vmcore_init+0x26c/0xab7
>>  [<c199979b>] init+0xaa/0x287
>>  [<c16044eb>] kernel_thread_helper+0x7/0x10
>>  =======================
>>
>> l *copy_oldmem_page+0x4a/0xd0
>> 0xc1610148 is in copy_oldmem_page (arch/i386/kernel/crash_dump.c:35).
>> 30       * copying the data to a pre-allocated kernel page and then copying to user
>> 31       * space in non-atomic context.
>> 32       */
>> 33      ssize_t copy_oldmem_page(unsigned long pfn, char *buf,
>> 34                                     size_t csize, unsigned long offset, int userbuf)
>> 35      {
>> 36              void  *vaddr;
>> 37
>> 38              if (!csize)
>> 39                      return 0;
>>
> 
> Can you please paste the disassembly of copy_oldmem_page() on your system.

disassemble *copy_oldmem_page
Dump of assembler code for function copy_oldmem_page:
0xc1610148 <copy_oldmem_page+0>:        push   %ebp
0xc1610149 <copy_oldmem_page+1>:        mov    %esp,%ebp
0xc161014b <copy_oldmem_page+3>:        push   %edi
0xc161014c <copy_oldmem_page+4>:        push   %esi
0xc161014d <copy_oldmem_page+5>:        push   %ebx
0xc161014e <copy_oldmem_page+6>:        sub    $0xc,%esp
0xc1610151 <copy_oldmem_page+9>:        call   0xc160f5c4 <mcount>
0xc1610156 <copy_oldmem_page+14>:       mov    0x8(%ebp),%ebx
0xc1610159 <copy_oldmem_page+17>:       xor    %edx,%edx
0xc161015b <copy_oldmem_page+19>:       cmpl   $0x0,0x10(%ebp)
0xc161015f <copy_oldmem_page+23>:       je     0xc161020d <copy_oldmem_page+197>
0xc1610165 <copy_oldmem_page+29>:       call   0xc1661258 <pagefault_disable>
0xc161016a <copy_oldmem_page+34>:       shl    $0x5,%ebx
0xc161016d <copy_oldmem_page+37>:       add    0xc1d68e60,%ebx
0xc1610173 <copy_oldmem_page+43>:       mov    %ebx,(%esp)
0xc1610176 <copy_oldmem_page+46>:       call   0xc1613577 <kmap>
0xc161017b <copy_oldmem_page+51>:       mov    %eax,%ebx
0xc161017d <copy_oldmem_page+53>:       cmpl   $0x0,0x18(%ebp)
0xc1610181 <copy_oldmem_page+57>:       jne    0xc16101ad <copy_oldmem_page+101>
0xc1610183 <copy_oldmem_page+59>:       mov    0x10(%ebp),%ecx
0xc1610186 <copy_oldmem_page+62>:       shr    $0x2,%ecx
0xc1610189 <copy_oldmem_page+65>:       mov    0x14(%ebp),%eax
0xc161018c <copy_oldmem_page+68>:       lea    (%ebx,%eax,1),%esi
0xc161018f <copy_oldmem_page+71>:       mov    0xc(%ebp),%edi
0xc1610192 <copy_oldmem_page+74>:       rep movsl %ds:(%esi),%es:(%edi)
0xc1610194 <copy_oldmem_page+76>:       mov    0x10(%ebp),%ecx
0xc1610197 <copy_oldmem_page+79>:       and    $0x3,%ecx
0xc161019a <copy_oldmem_page+82>:       je     0xc161019e <copy_oldmem_page+86>
0xc161019c <copy_oldmem_page+84>:       rep movsb %ds:(%esi),%es:(%edi)
0xc161019e <copy_oldmem_page+86>:       call   0xc166126e <pagefault_enable>
0xc16101a3 <copy_oldmem_page+91>:       mov    %ebx,(%esp)
0xc16101a6 <copy_oldmem_page+94>:       call   0xc1613533 <kunmap_virt>
0xc16101ab <copy_oldmem_page+99>:       jmp    0xc161020a <copy_oldmem_page+194>
0xc16101ad <copy_oldmem_page+101>:      mov    0xc19d4004,%edi
0xc16101b3 <copy_oldmem_page+107>:      test   %edi,%edi
0xc16101b5 <copy_oldmem_page+109>:      jne    0xc16101ca <copy_oldmem_page+130>
0xc16101b7 <copy_oldmem_page+111>:      movl   $0xc18bbc93,(%esp)
0xc16101be <copy_oldmem_page+118>:      call   0xc1619671 <printk>
0xc16101c3 <copy_oldmem_page+123>:      mov    $0xfffffff2,%edx
0xc16101c8 <copy_oldmem_page+128>:      jmp    0xc161020d <copy_oldmem_page+197>
0xc16101ca <copy_oldmem_page+130>:      mov    $0x400,%ecx
0xc16101cf <copy_oldmem_page+135>:      mov    %eax,%esi
0xc16101d1 <copy_oldmem_page+137>:      rep movsl %ds:(%esi),%es:(%edi)
0xc16101d3 <copy_oldmem_page+139>:      call   0xc166126e <pagefault_enable>
0xc16101d8 <copy_oldmem_page+144>:      mov    %ebx,(%esp)
0xc16101db <copy_oldmem_page+147>:      call   0xc1613533 <kunmap_virt>
0xc16101e0 <copy_oldmem_page+152>:      mov    0x10(%ebp),%eax
0xc16101e3 <copy_oldmem_page+155>:      mov    %eax,0x8(%esp)
0xc16101e7 <copy_oldmem_page+159>:      mov    0xc19d4004,%eax
0xc16101ec <copy_oldmem_page+164>:      add    %eax,0x14(%ebp)
0xc16101ef <copy_oldmem_page+167>:      mov    0x14(%ebp),%eax
0xc16101f2 <copy_oldmem_page+170>:      mov    %eax,0x4(%esp)
0xc16101f6 <copy_oldmem_page+174>:      mov    0xc(%ebp),%eax
0xc16101f9 <copy_oldmem_page+177>:      mov    %eax,(%esp)
0xc16101fc <copy_oldmem_page+180>:      call   0xc1700e98 <copy_to_user>
0xc1610201 <copy_oldmem_page+185>:      mov    $0xfffffff2,%edx
0xc1610206 <copy_oldmem_page+190>:      test   %eax,%eax
0xc1610208 <copy_oldmem_page+192>:      jne    0xc161020d <copy_oldmem_page+197>
0xc161020a <copy_oldmem_page+194>:      mov    0x10(%ebp),%edx
0xc161020d <copy_oldmem_page+197>:      mov    %edx,%eax
0xc161020f <copy_oldmem_page+199>:      add    $0xc,%esp
0xc1610212 <copy_oldmem_page+202>:      pop    %ebx
0xc1610213 <copy_oldmem_page+203>:      pop    %esi
0xc1610214 <copy_oldmem_page+204>:      pop    %edi
0xc1610215 <copy_oldmem_page+205>:      pop    %ebp
0xc1610216 <copy_oldmem_page+206>:      ret
End of assembler dump.


> Not sure from where this faulting address 0xf7ebf8c4 is coming. We are still
> in vmcore_init(), so we should be copying the data to kernel buffers only.
> This looks like a valid kernel address.
> 
> Can you also put some printk() here to find out from where 0xf7ebf8c4 has
> come? It does not look like a fixed kernel virutual address returned by
> kmap_atomic_pfn(). Then is it passed by kernel as a parameter to
> copy_oldmem_page()?
> 
> Thanks
> Vivek
> 

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
