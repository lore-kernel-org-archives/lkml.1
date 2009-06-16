Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbZFPM5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbZFPM5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 08:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZFPMze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 08:55:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:44898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834AbZFPMza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 08:55:30 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v3 0/9] clean up vdso-layout.lds.S
Date: Tue, 16 Jun 2009 14:55:20 +0200
Message-Id: <1245156929-30395-1-git-send-email-ptesarik@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The handling of various sections in the VDSO linker script
looks pretty haphazard. This patch series cleans it up in
these regards:

 - improve the coding style
 - remove superfluous sections
 - issue a linker error if a section is encountered which
   is known not to work
 - check that the .got section is empty, except for the
   three entries defined by the ABI
 - discard sections which are not useful to user-space

Petr Tesarik (9):
  x86: Adjust the coding style of vdso-layout.lds.S
  x86: Remove .sdata from the vDSO linker script
  x86: add .broken section to the vDSO linker script
  x86: mark altinstr-related sections in vDSO as broken
  x86: mark some standard sections as broken in a vDSO
  x86: move 32-bit vDSO padding from .data to .rodata
  x86: mark writable vDSO sections as broken
  x86: check the size of GOT in vDSO
  x86: remove .gnu.warning* sections from the vDSO

 arch/x86/vdso/Makefile          |    5 +-
 arch/x86/vdso/vdso-layout.lds.S |  158 ++++++++++++++++++++++++++++++++-------
 arch/x86/vdso/vdso32/int80.S    |    2 +-
 arch/x86/vdso/vdso32/syscall.S  |    2 +-
 4 files changed, 136 insertions(+), 31 deletions(-)

