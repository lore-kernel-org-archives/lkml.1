Return-Path: <linux-kernel-owner+w=401wt.eu-S938821AbXG1CCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938821AbXG1CCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 22:02:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938471AbXG1CCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 22:02:05 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49165 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704AbXG1CCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 22:02:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [BUG] i386 relocable kernel breakes /proc/kcore debugging
References: <200707280443.44048.maximlevitsky@gmail.com>
Date: Fri, 27 Jul 2007 19:58:56 -0600
In-Reply-To: <200707280443.44048.maximlevitsky@gmail.com> (Maxim Levitsky's
	message of "Sat, 28 Jul 2007 04:43:43 +0300")
Message-ID: <m1fy39thjz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim Levitsky <maximlevitsky@gmail.com> writes:

> Hello,
>
> Today I noticed that gdb gets confused when I try to load a vmlinux image.
> gdb 'thinks' that all kernel symbols are below 0x80000000 , while they are at 
> 0xC000....
>
> Turning CONFIG_RELOCATABLE off fixes that, so I assume that is the reason for 
> that.
>
> I am using 2.6.23-rc1, although I don't think that older versions are better.
>
> Best regards,
> 	Maxim Levitsky

Weird.

Vivek could this be related to the problem of problematic core dumps we
were seeing earlier?

Eric


> PS: 
> This is what gdb says:

>
> (gdb) disassemble sys_open
> Dump of assembler code for function sys_open:
> 0x8026fa60 <sys_open+0>:        Cannot access memory at address 0x8026fa60
>
> While real address of sys_open is:
>
> [root@MAIN linux-2.6]# nm ./.obj/vmlinux |  grep sys_open
> .........
> c016ea60 T sys_open
>
> Strange, but gdb recordnizes the above address directly:
>
> (gdb) disassemble 0xc016ea60
> Dump of assembler code for function sys_open:
> 0xc016ea60 <sys_open+0>:        sub    $0x4,%esp
> 0xc016ea63 <sys_open+3>:        mov    0x10(%esp),%eax
> ...............
