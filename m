Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYH3PaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYH3PaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 11:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYH3PaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 11:30:06 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:29792 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbYH3PaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 11:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=HptHmPUaZh5lc9TORTQmFbl9f+gaF+wMEOcg3OfZFN79VvRw7d1snp6G7LjDzPs+yO
         AXTND8b/+jMYFCAJ4l0cfpq+6rHjd8l95evD4tJb97FWNcJxMgYiemG3IAIZEA/QRgem
         wsb6K32+u7miJZqwIwv/5ChYD4t2BlYcGLUEA=
Message-ID: <19f34abd0808300830q25cef20chf5f905af210198c4@mail.gmail.com>
Date: Sat, 30 Aug 2008 17:30:00 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Thomas Backlund" <tmb@mandriva.org>
Subject: Re: BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <48B94120.1010108@mandriva.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B94120.1010108@mandriva.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2008 at 2:46 PM, Thomas Backlund <tmb@mandriva.org> wrote:
> Hi, (please cc me as I'm not subscribed)
>
> thought I would post this right now, I'll try to reproduce it with vanilla
> 2.6.27-rc5 as soon as the buildhost is back up...
>
> (vanilla 2.6.27-rc5 x86_64 also locked up my laptop wich is a
>  Core2 Duo T8300 during kernel build with make -j3, but
>  I dont have any logs of that yet)
>
> Kernel: 2.6.27-rc5 + Mandriva patches
> Config:
> http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel/branches/rebase-to-2.6.27/PATCHES/configs/x86_64.config?revision=276760&view=markup
> Arch: x86_64
>
> System: Intel Quad Core Q9300
>
> getting this with netconsole while building kernel rpms with make -j5:

Hi,

I tried your recipe. Well, not exactly. But I also got this during a
kernel build. Notice that the kernel version is a clean v2.6.27-rc5
(i.e. latest Linus -git):

BUG: soft lockup - CPU#1 stuck for 61s! [swapper:0]
irq event stamp: 3585444
hardirqs last  enabled at (3585443): [<c015927b>] trace_hardirqs_on+0xb/0x10
hardirqs last disabled at (3585444): [<c0290614>] trace_hardirqs_off_thunk+0xc/8
softirqs last  enabled at (3585438): [<c0139fb1>] __do_softirq+0xe1/0x100
softirqs last disabled at (3585427): [<c013a075>] do_softirq+0xa5/0xb0

Pid: 0, comm: swapper Not tainted (2.6.27-rc5-00006-gbef69ea #3)
EIP: 0060:[<c011eb55>] EFLAGS: 00000202 CPU: 1
EIP is at native_safe_halt+0x5/0x10
EAX: 0036b5a3 EBX: c2161b80 ECX: 00000000 EDX: 00000000
ESI: 00000001 EDI: c090fb80 EBP: f7855f80 ESP: f7855f80
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0807a0b0 CR3: 3695d000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c010ad80>] default_idle+0x50/0x70
 [<c01029c8>] cpu_idle+0x68/0x130
 [<c059e120>] start_secondary+0x160/0x1c0
 =======================

c011eb50 <native_safe_halt>:
c011eb50:       55                      push   %ebp
c011eb51:       89 e5                   mov    %esp,%ebp
c011eb53:       fb                      sti
c011eb54:       f4                      hlt
c011eb55:       5d                      pop    %ebp
c011eb56:       c3                      ret
c011eb57:       89 f6                   mov    %esi,%esi
c011eb59:       8d bc 27 00 00 00 00    lea    0x0(%edi),%edi

...there's not many clues here as to what went wrong. Curious.

(Yes, I played with CPU hotplug and hibernate as well.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
