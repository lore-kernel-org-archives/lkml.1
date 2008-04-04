Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbYDDMk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbYDDMk6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 08:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755277AbYDDMkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 08:40:51 -0400
Received: from aun.it.uu.se ([130.238.12.36]:45514 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752756AbYDDMku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 08:40:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18422.8628.510177.819697@harpo.it.uu.se>
Date: Fri, 4 Apr 2008 14:40:20 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24 still doesn't boot on i486..
In-Reply-To: <47F5EE6A.6080705@msgid.tls.msk.ru>
References: <47F5EE6A.6080705@msgid.tls.msk.ru>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev writes:
 > Just a follow-up on my earlier bugreport, when
 > 2.6.23 first come out....
 > 
 > 2.6.24 seems to not boot on i486-class hardware.
 > The machine reboots right after "Booting linux"
 > message.  2.6.22 was the last worked kernel.
 > 
 > The relevant config entries are:
 > 
 > CONFIG_TICK_ONESHOT=y
 > CONFIG_NO_HZ=y
 > CONFIG_HIGH_RES_TIMERS=y
 > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 > CONFIG_X86_PC=y
 > CONFIG_M486=y
 > CONFIG_X86_GENERIC=y
 > CONFIG_X86_CMPXCHG=y          <-- is it right?

yes

 > CONFIG_X86_L1_CACHE_SHIFT=7
 > CONFIG_X86_XADD=y
 > CONFIG_X86_PPRO_FENCE=y
 > CONFIG_X86_F00F_BUG=y
 > CONFIG_X86_WP_WORKS_OK=y
 > CONFIG_X86_INVLPG=y
 > CONFIG_X86_BSWAP=y
 > CONFIG_X86_POPAD_OK=y
 > CONFIG_X86_ALIGNMENT_16=y
 > CONFIG_X86_INTEL_USERCOPY=y
 > CONFIG_X86_MINIMUM_CPU_FAMILY=4
 > CONFIG_X86_UP_APIC=y
 > CONFIG_X86_UP_IOAPIC=y
 > CONFIG_X86_LOCAL_APIC=y
 > CONFIG_X86_IO_APIC=y
 > CONFIG_X86_MCE=y
 > CONFIG_X86_MCE_NONFATAL=y
 > CONFIG_X86_MCE_P4THERMAL=y
 > CONFIG_NOHIGHMEM=y
 > CONFIG_VMSPLIT_3G=y
 > 
 > Compiled with gcc (GCC) 4.2.3 (Debian 4.2.3-2).
 > 
 > This email is also a JFYI-style email.  Yesterday
 > I tried to debug this issue but discovered that the
 > power unit of that machine failed.  Well, it still
 > works and the machine boots, but at the same time
 > it smells like frosted/fried plastic ;)  So I don't
 > have i486 hardware anymore to test things on...
 > 
 > And now I wonder if I'm the only person in this world
 > with i486 machine... ;)

Just FYI, 2.6.23, 2.6.24 and 2.6.25-rc6 work fine on my i486DX4.

However, it's clear from your .config fragment above that you've
enabled features that cannot possibly exist on a 486 (APICs and
MCE for starters) and there may be bugs related to that. I suggest
trimming your .config and making it 486-specific.
