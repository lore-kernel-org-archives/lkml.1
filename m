Return-Path: <linux-kernel-owner+w=401wt.eu-S1758662AbZCXLOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662AbZCXLOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 07:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZCXLO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 07:14:26 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55311 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847AbZCXLOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 07:14:25 -0400
Message-ID: <49C8C08B.9010100@monstr.eu>
Date: Tue, 24 Mar 2009 12:14:19 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.17 (X11/20081001)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 07/57] microblaze_v7: Signal support
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu> <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <200903232035.15100.arnd@arndb.de>
In-Reply-To: <200903232035.15100.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Wednesday 18 March 2009, monstr@monstr.eu wrote:
>> From: Michal Simek <monstr@monstr.eu>
>>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/include/asm/signal.h |  165 +++++++++++
>>  arch/microblaze/kernel/signal.c      |  536 ++++++++++++++++++++++++++++++++++
>>  2 files changed, 701 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/microblaze/include/asm/signal.h
>>  create mode 100644 arch/microblaze/kernel/signal.c
> 
>> From: Michal Simek <monstr@monstr.eu>
>>
>>
>> Signed-off-by: Michal Simek <monstr@monstr.eu>
>> ---
>>  arch/microblaze/include/asm/ipc.h       |    1 +
>>  arch/microblaze/include/asm/ipcbuf.h    |   36 +++++
>>  arch/microblaze/kernel/sys_microblaze.c |  226 +++++++++++++++++++++++++++++++
>>  3 files changed, 263 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/microblaze/include/asm/ipc.h
>>  create mode 100644 arch/microblaze/include/asm/ipcbuf.h
>>  create mode 100644 arch/microblaze/kernel/sys_microblaze.c
> 
> I don't quite remember what the outcome of this discussion was the last
> time, but what is your plan for the deprecated syscalls like the
> legacy syscalls you add here?
> 
> Have you tried changing uClibc and/or glibc so you don't need them?
> Are you planning to remove them soon once they are not needed any
> more?
> 
> What about the syscalls that are not needed but you just get from
> common code (e.g. oldumount, time, old_readdir, ...)?

I think that my emails from yesterday don't go through.

Here are our updated results in this area.
We have noMMU and MMU microblaze version and we use almost the same syscall
table for them. That's not correct in all cases but we have it.

>From noMMU and uClibc perspective. We are still using gcc 3.4.1 and we are
working on gcc 4.1.2 with latest uClibc.
>From uClibc perspective. is almost all clear. We have latest version and when
new gcc are ready I start to work on it and of course add new syscall to uClibc
will take a time but I believe that is only work which is not so hard.

>From MMU and glibc perspective. We have and use gcc 4.1.2 with any ancient glibc
version.
Glibc version with Microblaze support is not based on any public version and we
can't easily create patches and upgrade them to latest version. We are preparing
work on it but this will be a long time project.

I am trying to add only noMMU kernel because MMU kernel is still new (only 2
month with FDT) and I do LTP test on it MMU kernel share a lot of code with
noMMU version and reviewing is easier. MMU version will come in future for
reviewing too.

That's the current state.
I don't like this situation but I have to work with it. On the base on
information which are above I have only some choices.
1. Wait till both tools are ready for syscall cleanup and then try to add
microblaze to kernel.org.
2. Update only uClibc but latest uClibc version needs newer gcc which I don't
have now.
3. Keep old syscalls and sys_ipc for example which are tested and are used for a
long time.

I hope you understand our situation. That's why I decided to have old syscalls.
Both version(noMMU and MMU) work. And we are working on new libcs. They will
need a time for testing too.
For me is better to have working stable version and in future remove old
syscalls and clean code (for example sys_ipc).

Thanks,
Michal




> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
