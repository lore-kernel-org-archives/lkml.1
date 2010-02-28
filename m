Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031993Ab0B1UKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:10:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031966Ab0B1UKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:10:19 -0500
Date: Sun, 28 Feb 2010 12:09:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
In-Reply-To: <20100227150942.GA6394@elte.hu>
Message-ID: <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>
References: <20100227150942.GA6394@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I haven't bisected this, but something slowed down in bootup on my machine 
recently.

See the timestamps:

	[    0.000000] Linux version 2.6.33-01832-g30ff056 
	...
	[    0.010066] Enabled Interrupt-remapping
	[    0.010120] Setting APIC routing to physical flat
	[    0.010180] DRHD: handling fault status reg 2
	[    0.010582] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
	[    0.049955] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
	[    0.157195] Booting Node   0, Processors  #1
	[    0.245179] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
	[    0.265332]  #2
	[    0.353185] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
	[    0.373328]  #3
	[    2.193277] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
	[    2.213379]  #4
	[    2.301283] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    2.321391]  #5
	[    2.417287] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    2.437356]  #6
	[    2.525293] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    2.545354]  #7
	[    2.633298] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    2.653423] Brought up 8 CPUs
	[    2.653571] Total of 8 processors activated (51201.44 BogoMIPS).

what happened there for almost 2 seconds in between CPU#3 and CPU#4?

It wasn't very fast before either, but it was way better:

	[    0.050298] CPU0: Genuine Intel(R) CPU             000  @ 3.20GHz stepping 04
	[    0.156725] Booting Node   0, Processors  #1
	[    0.244410] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
	[    0.264458]  #2
	[    0.352078] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
	[    0.372147]  #3
	[    0.459746] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6 SHD:8
	[    0.479838]  #4
	[    0.567415] CPU 4 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    0.587446]  #5
	[    0.683057] CPU 5 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    0.703081]  #6
	[    0.790724] CPU 6 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    0.810748]  #7
	[    0.898393] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	[    0.918412] Brought up 8 CPUs
	[    0.918562] Total of 8 processors activated (51203.34 BogoMIPS).

what is it that takes so long to bring those CPU's up?

		Linus
