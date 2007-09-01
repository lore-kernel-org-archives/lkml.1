Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXIAVrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXIAVrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756577AbXIAVr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:47:26 -0400
Received: from barikada.upol.cz ([158.194.242.200]:44578 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbXIAVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:47:25 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: "T. J. Brumfield" <enderandrew@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: about modularization
In-Reply-To: <20070803131900.GA26203@elte.hu>
References: <cdc89fe60708030507r29283942mbb9947edbe04e23a@mail.gmail.com> <20070803131900.GA26203@elte.hu>
Date: Sun, 2 Sep 2007 00:02:22 +0200
Message-Id: <E1IRb2s-0001Qp-5j@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Date: Fri, 3 Aug 2007 15:19:00 +0200
* Received-SPF: softfail (mx3: transitioning domain of elte.hu does not designate 157.181.1.14 as permitted sender) client-ip=157.181.1.14; envelope-from=mingo@elte.hu; helo=elvis.elte.hu;

> If you boot into a distro kernel on 
> a typical PC, about half of the kernel code that the box runs in any 
> moment will be in modules, half of it is in the "kernel core". For 
> example, on a random laptop:

That was your laptop and distro.

>  $ echo `lsmod | cut -c1-30 | cut -d' ' -f2-` | sed 's/Size //' |
>    sed 's/ /+/g' | bc
>  2513784
>
> i.e. 2.5 MB of modules. The core kernel's size:
>
>  $ dmesg | grep 'kernel code'
>  Memory: 2053212k/2087808k available (2185k kernel code, 33240k reserved, 1174k data, 244k init, 1170304k highmem)
>
> 2.1 MB of kernel core code. (of course the total body of "possible 
> drivers" is 10 times larger than that of the core kernel - but the 
> fundamental 'variety' is not.)

Just for reference here's my 2+ years old Asus A4K, kernel is form
Debian Etch:

deen:/tmp# uname -a
Linux deen 2.6.18-4-amd64 #1 SMP Mon Mar 26 11:36:53 CEST 2007 x86_64 x86_64
deen:/tmp# lsmod | (read a; while read a b c; do S=$((b+${S=0})); done; echo $S)
1583684                                                                        
deen:/tmp# lsmod | grep xfs                                                    
xfs                   485192  3                                                
deen:/tmp# dmesg | grep kernel\ code                                           
Memory: 506676k/523520k available (1930k kernel code, 16456k reserved, 868k data, 176k init)

Apart from diff in hardware and implied designing/coding skills, decision
was made

* after one "wrong" response plus illness from Con,
* brave core-duo by Ingo and Tomas, who made some bunch of students to test
  scheduler and reported success to Linus.

I don't know why, after all that variety of things (mostly drivers, but
recent *fd also) there's such big resistance to anything that's useful
and used by ordinary people. A star sickness, pride? If yes, that's just
ridiculous, but who cares.
____
