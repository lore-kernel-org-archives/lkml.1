Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbZCXDM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbZCXDM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 23:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZCXDMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 23:12:47 -0400
Received: from smtp1.Stanford.EDU ([171.67.219.81]:46585 "EHLO
	smtp1.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbZCXDMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 23:12:46 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090323080724.GA13569@elte.hu>
References: <1235619922.31774.17.camel@localhost.localdomain>
	 <1236984825.10748.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain>
	 <1237661053.3196.10.camel@localhost.localdomain>
	 <20090321184904.GA19352@elte.hu>
	 <1237662372.3574.2.camel@localhost.localdomain>
	 <1237663624.3200.3.camel@localhost.localdomain>
	 <1237687635.3424.1.camel@localhost.localdomain>
	 <20090322130937.GA22848@elte.hu>
	 <1237758228.18021.8.camel@localhost.localdomain>
	 <20090323080724.GA13569@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 20:13:24 -0700
Message-Id: <1237864404.3441.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 09:07 +0100, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > On Sun, 2009-03-22 at 14:09 +0100, Ingo Molnar wrote:
> > > * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> > I hit another problem. On a quad code intel machine here at home there
> > is a problem during shutdown. The final shutdown dies with a traceback
> > (something like "rc0 was killed by SIGSEGV" or similar words at the very
> > end). Then I have to push the power button for x+ seconds to force a
> > power off. 
> > 
> > Should I post a picture of the screen as it is at that point, or just
> > send that to you and Thomas? 
> 
> any kernel stack dump in that?

The tail end of it. 
(still happening in rc8-rt4)

> You could try to do this before shutting down:
> 
>   echo 1 > /proc/sys/kernel/print-fatal-signals
>   dmesg -n 8
> 
> that way there's a (hopefully helpful) stack dump done of the 
> SIGSEGV itself.

without all the funny numbers this is what remains on screen:

  native_cpu_die
  _cpu_down
  disable_nonboot_cpus
  kernel_power_off
  sys_reboot
  __hrtimer_start_range_ns
  default_spin_lock_flags
  __spin_lock_irqsave
  __spin_lock_irqrestore
  hrtimer_try_to_cancel
  hrtimer_cancel
  do_nanosleep
  hrtimer_nanosleep
  hrtimer_wakeup
  path_put
  audit_syscall_entry
  audit_syscall_exit
  sysenter_do_call
Code: 00 00 6a 00 ff 15 08 49 85 c0 58 etc etc etc
EIP [<c06f2549>] text_poke+0x163/0x181 SS:ESP 0068:f4567ddc
-- [end trace db3e80122adba82c ]---
init: rc0 main process (3047) killed by SEGV signal

(I can take a picture if that would help - I don't have a second machine
with a serial port to try to capture the whole thing)

BTW, the hard disk powers down and everything else seems to complete. 

-- Fernando


