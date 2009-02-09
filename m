Return-Path: <linux-kernel-owner+w=401wt.eu-S1755066AbZBIMec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbZBIMec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZBIMeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:34:24 -0500
Received: from ftp.linux-mips.org ([213.58.128.207]:38869 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbZBIMeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:34:23 -0500
Date: Mon, 9 Feb 2009 12:34:21 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: check_timer cleanup
In-Reply-To: <20090209114520.GE18757@elte.hu>
Message-ID: <alpine.LFD.1.10.0902091226400.12457@ftp.linux-mips.org>
References: <20090206220716.GA15319@elte.hu> <498D55A4.7000608@kernel.org> <20090207165901.GA32116@elte.hu> <498E6A3C.6020004@kernel.org> <20090209081542.GF24420@elte.hu> <alpine.LFD.1.10.0902091129150.12457@ftp.linux-mips.org>
 <20090209114520.GE18757@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009, Ingo Molnar wrote:

> >  What problems are you referring to, Ingo?  Perhaps they should be looked 
> > into specifically?
> 
> I got a spurious boot failure on a 64-bi testbox:
> 
> [    0.280000] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.296000] ..MP-BIOS bug: 8254 timer not connected to IO-APIC
> [    0.296000] ...trying to set up timer (IRQ0) through the 8259A ...
> [    0.296000] ..... (found apic 0 pin 2) ...
> [    0.308000] ....... failed.
> [    0.308000] ...trying to set up timer as Virtual Wire IRQ...
> [    0.324000] ..... failed.
> [    0.324000] ...trying to set up timer as ExtINT IRQ...
> [    0.340000] ..... failed :(.
> [    0.340000] Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug and send a report.  Then try booting with the 'noapic' option.
> 
> Not reproducible. Full bootlog below.

 If so, it could have been anything.  Even a casual hardware failure.  The 
timer retriggers by itself producing both edges automatically, so even if 
an edge is missed because of the mask, another one follows shortly.  I 
don't think the change proposed by Yinghai would make any difference here.

 Pity you can't use an in-circuit debugger with the x86... :(

  Maciej
