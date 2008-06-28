Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbYF1TvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbYF1TvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 15:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYF1Tu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 15:50:56 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbYF1Tuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 15:50:55 -0400
Date: Sat, 28 Jun 2008 22:02:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Agner Fog <agner@agner.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
Message-ID: <20080628200231.GA21259@one.firstfloor.org>
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com> <4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org> <4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org> <4866541F.1060709@agner.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4866541F.1060709@agner.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This info is not in the "Unreliable Guide To Hacking The Linux Kernel" 

The unreliable guide is a little outdated.

> or anywhere else except deeply hidden in the archives of this mailing 

Normally all introductions of kernel programming (like
the classic "Linux device drivers") should document that FPU code
is not allowed. The kernel also enforces that by passing special
compiler optionsthat cause compiler errors for FPU and SSE code.
You have to explicitely override those.

> list. I had to actually look into the source code of kernel_fpu_begin to 
> verify that it saves not only the FPU but also the XMM registers and 
> that it disables pre-emption.

The requirement to disable preemption is one reason why XMM in 
a driver is not a good idea BTW.  XMM should be normally only
used when you plan to spend a lot of CPU cycles (otherwise
the cost of saving the state is not amortized by the improvements).

But keeping preemption disabled for a long time is considered
unfriendly because it increases kernel latencies and might 
in the worst case cause visible scheduling problems like skipping audio
etc. 

> You see why I want proper documentation? If this had been documented in 
> some reference that was easy to find, I wouldn't have needed to take 
> your time with all these questions...

Yes agreed the documentation could be better. The standard Linux
reference documentation is "kerneldoc" which you can generate from the 
kernel source with make pdfdocs/mandocs/htmldocs
(some distributions ship pregenerated docs in a separate kernel-docs package)

Unfortunately kerneldoc documents a lot of obscure unimportant
functions, but doesn't document important functionality like
kernel_fpu_begin/end (or even important functions like kmalloc!)

There's a new editor for kernel documentation now so things might
improve.

-Andi

