Return-Path: <linux-kernel-owner+w=401wt.eu-S1760077AbZFKTV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077AbZFKTV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756356AbZFKTUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:20:46 -0400
Received: from claw.goop.org ([74.207.240.146]:44162 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZFKTUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:20:45 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] x86/paravirt: clean up paravirt.h and optimise FPU context switch
Date: Thu, 11 Jun 2009 12:20:35 -0700
Message-Id: <1244748040-27185-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This series:
 - splits asm/paravirt.h into paravirt.h and paravirt_types.h
 - splits out the context switch core of math_state_restore into __math_state_restore
 - rearranges 32 and 64 bit context switch to be the same and to properly
   batch FPU context switches when running paravirtualized

There should be no performance side-effects of these changes.  They amount
to a small rearrangement of the existing code (and bringing the 64-bit
code a bit closer to 32-bit, countering some genetic drift).

I think these are probably safe to go into this merge window, but I
don't think I've posted these before, so I understand if you're hesitant
(I've had them applied locally for some time with no ill-effects).
The paravirt cleanup is pure movement between headers, so I don't think
there's much risk there at all.

 arch/x86/include/asm/i387.h           |    1 +
 arch/x86/include/asm/paravirt.h       |  711 +--------------------------------
 arch/x86/include/asm/paravirt_types.h |  720 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c          |   27 +-
 arch/x86/kernel/process_64.c          |   33 +-
 arch/x86/kernel/traps.c               |   33 +-
 6 files changed, 782 insertions(+), 743 deletions(-)

Thanks,
	J

