Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297AbXLHTd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbXLHTd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 14:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751502AbXLHTdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 14:33:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:29182 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXLHTds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 14:33:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Tz04AfrXaOLQ7hl/NcV0G5bCdxsB/WFMHC/z0Q3c/vq8LD3irJNFo+OTAq6daA0lkPP1Abva/8VrWNPsl2S9g26Cp9gL5vfPPowScN98/dagcSj6ibJwrgqkzJlTIH1NrUcBj+4Bli6CwsExXC0XzkldhmzDF4cx9h257e37wPY=
Message-ID: <82e4877d0712081133y49fec9bfyee30a3010b37c435@mail.gmail.com>
Date: Sat, 8 Dec 2007 14:33:48 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: soft lockup - CPU#1 stuck for 15s! [swapper:0]
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20071208191330.GA21186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <82e4877d0712071453h38795e36of26324a4b123fa6c@mail.gmail.com>
	 <924EFEDD5F540B4284297C4DC59F3DEE38C3C2@orsmsx423.amr.corp.intel.com>
	 <alpine.LFD.0.99999.0712080821220.3070@localhost.localdomain>
	 <82e4877d0712080710g205ba93ag12ee204b15d70fdb@mail.gmail.com>
	 <82e4877d0712080736v12c1e31at9149655ae000fe50@mail.gmail.com>
	 <20071208154755.GA5255@elte.hu>
	 <82e4877d0712080800j6572734ek78a76cf7bb17a7e0@mail.gmail.com>
	 <20071208191330.GA21186@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 8, 2007 2:13 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
>
> > >    while :; do time usleep 1111111; done
> > >
> > > or do these sleeps fluctuate?
> >
> > They seem to fluctuate - not sure if that's supposed to be exact or if
> > below variations are normal - This is when my compiles are running -
>
> it's normal for them to fluctuate a little when load goes up and the
> task gets delayed.
>
> 'bad' fluctuations are ones that happen when the system is idle.
>

Even on 100% idle I get variations that are approx in the same range
when not idle.
Clocksource is hpet if that matters.  Next I think I will disable
CPU_IDLE, Tickless

My ssh connection just died - another lockup in dmesg -

BUG: soft lockup - CPU#1 stuck for 14s! [sshd:509]

Pid: 509, comm: sshd Not tainted (2.6.24-rc4 #6)
EIP: 0060:[<c060540b>] EFLAGS: 00200206 CPU: 1
EIP is at do_page_fault+0x117/0x583
EAX: ef5aaa80 EBX: 0048cfc0 ECX: 0000007b EDX: 00000003
ESI: ef691fb8 EDI: b7ca1ab4 EBP: ef47f050 ESP: ef691f70
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7ca1ab4 CR3: 2f555000 CR4: 000006d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c06052f4>] do_page_fault+0x0/0x583
 [<c06040aa>] error_code+0x72/0x78
 [<c0600000>] netlbl_domhsh_walk+0x94/0xba


$> while :; do time usleep 1111111; done
real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.385s
user    0m0.000s
sys     0m0.004s

real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.112s
user    0m0.000s
sys     0m0.000s

real    0m1.279s
user    0m0.000s
sys     0m0.000s
