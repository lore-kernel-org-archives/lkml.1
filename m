Return-Path: <linux-kernel-owner+w=401wt.eu-S1754047AbYECT5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047AbYECT5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYECT4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:56:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbYECT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:56:53 -0400
Message-ID: <481CC360.4090506@zytor.com>
Date: Sat, 03 May 2008 12:56:16 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, Mikael Pettersson <mikpe@it.uu.se>,
       jamal <hadi@cyberus.ca>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de> <18460.46554.826031.184323@harpo.it.uu.se> <481CB82D.60404@zytor.com> <alpine.LFD.1.10.0805032115330.6003@apollo.tec.linutronix.de> <481CBBF2.4090501@zytor.com> <20080503195448.GE25097@elte.hu>
In-Reply-To: <20080503195448.GE25097@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>>> This might also be caused by a calibration error. We've seen enough 
>>> of them already.
>> No doubt.  However, there is *something* ugly going on.
> 
> i think a vital clue can be found in the original report:
> 
> |  I am able to reproduce the issue consistently on my laptop using qemu 
> |  (which helped speed debugging a bit). I have also narrowed it down to 
> |  include/asm-x86/i387.h::__save_init_fpu in (32 bit version) - it dies 
> |  somewhere in calling the following line:
> 
> so it might just be incorrect Qemu emulation of a PII's NOP instruction?
> 
> (which btw. probably proves that Linux is the first OS to make 
> intelligent use of those instructions?)
> 

Ah, yes, this is a Qemu bug, then.

And yes, it probably does mean exactly that :)

	-hpa
