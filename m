Return-Path: <linux-kernel-owner+w=401wt.eu-S1762550AbZATS2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762550AbZATS2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZATS2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:28:41 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:43871 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbZATS2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:28:40 -0500
Message-ID: <497617D6.8020707@ct.jp.nec.com>
Date: Tue, 20 Jan 2009 10:28:38 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Jesper Juhl <jj@chaosbits.net>, lkml <linux-kernel@vger.kernel.org>,
       John Stoffel <john@stoffel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [bisected] 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com> <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net> <4972489B.30500@gawab.com> <497260FE.4010102@gmail.com> <4972723B.4000201@gawab.com> <49727BDE.9070509@gmail.com> <49751BA0.1040004@gawab.com> <49752823.9020403@ct.jp.nec.com> <49756D07.7080804@gawab.com>
In-Reply-To: <49756D07.7080804@gawab.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Madru wrote:
> Hiroshi Shimamoto wrote:
>> Justin Madru wrote:
>>> Ok, finally bisected the bug, but the commit isn't related to networking!
>>> I did: git revert 4217458dafaa57d8e26a46f5d05ab8c53cf64191
>>> on current git and that fixed the bug.
>>>
>>> By the way, how do I undo my git revert, so I'm back to a pristine tree?
>>> I want to drop my changes - the revert.
>>> Also how do I find the commit that merged/pulled in this commit?
>>>
>>> commit 4217458dafaa57d8e26a46f5d05ab8c53cf64191
>>> Author: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>> Date: Fri Dec 5 17:17:09 2008 -0800
>>>
>>> x86: signal: change type of paramter for sys_rt_sigreturn()
>>>
>>> Impact: cleanup on 32-bit
>>>
>>> Peter pointed this parameter can be changed.
>>>
>>> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> Hi,
>> thanks for reporting.
>>
>> I'm not sure why this commit affects.
>> Can you check vmlinux? size, objdump, etc.
>> On my environment, the generated code looks same.
>>
>> Thanks,
>> Hiroshi
>>
> I tried to do an objdump but it gave an error. How am I suppose to do an 
> objdump?
> 
> $ objdump -x /boot/vmlinuz-2.6.29-rc2-git
> objdump: /boot/vmlinuz-2.6.29-rc2-git: File format not recognized
> $ readelf -a /boot/vmlinuz-2.6.29-rc2-git
> readelf: Error: Unable to seek to 0xc031f2eb for section headers
> readelf: Error: Not an ELF file - it has the wrong magic bytes at the start
> $ ls -la /boot/vmlinuz-2.6.29-rc2-git
> -rw-r--r-- 1 root root 2286480 2009-01-19 18:44 /boot/vmlinuz-2.6.29-rc2-git

not vmlinuz, vmlinux.
vmlinuz is a compressed kernel, it is not ELF file.
Usually vmlinux is generated in top of source directory.
I can see disassembled image with objdump -d vmlinux.

Thanks,
Hiroshi
