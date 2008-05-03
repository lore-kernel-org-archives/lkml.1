Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYECTzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYECTzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbYECTzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:55:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59990 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYECTzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:55:08 -0400
Date: Sat, 3 May 2008 21:54:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mikael Pettersson <mikpe@it.uu.se>,
       jamal <hadi@cyberus.ca>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
Message-ID: <20080503195448.GE25097@elte.hu>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <481CA40A.7040906@zytor.com> <alpine.LFD.1.10.0805032017290.6003@apollo.tec.linutronix.de> <18460.46554.826031.184323@harpo.it.uu.se> <481CB82D.60404@zytor.com> <alpine.LFD.1.10.0805032115330.6003@apollo.tec.linutronix.de> <481CBBF2.4090501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481CBBF2.4090501@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

>> This might also be caused by a calibration error. We've seen enough 
>> of them already.
>
> No doubt.  However, there is *something* ugly going on.

i think a vital clue can be found in the original report:

|  I am able to reproduce the issue consistently on my laptop using qemu 
|  (which helped speed debugging a bit). I have also narrowed it down to 
|  include/asm-x86/i387.h::__save_init_fpu in (32 bit version) - it dies 
|  somewhere in calling the following line:

so it might just be incorrect Qemu emulation of a PII's NOP instruction?

(which btw. probably proves that Linux is the first OS to make 
intelligent use of those instructions?)

	Ingo
