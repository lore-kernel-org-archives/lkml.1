Return-Path: <linux-kernel-owner+w=401wt.eu-S1764324AbZFLN0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764324AbZFLN0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761229AbZFLNZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:25:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:41665 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759993AbZFLNZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:25:41 -0400
From: Petr Tesarik <ptesarik@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Roland McGrath <roland@redhat.com>, Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH 0/8] clean up vdso-layout.lds.S
Date: Fri, 12 Jun 2009 15:25:34 +0200
Message-Id: <cover.1244812577.git.ptesarik@suse.cz>
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

Petr Tesarik (8):
  x86: Adjust the coding style of vdso-layout.lds.S
  x86: Remove .sdata from the vDSO linker script
  x86: Remove .dynbss from the vDSO linker script
  x86: add .broken section to the vDSO linker script
  x86: mark altinstr-related sections in vDSO as broken
  x86: mark some standard sections as broken in a vDSO
  x86: check the size of GOT in vDSO
  x86: remove unneeded section from the vDSO

 arch/x86/vdso/Makefile          |    5 +-
 arch/x86/vdso/vdso-layout.lds.S |  144 +++++++++++++++++++++++++++++++-------
 2 files changed, 120 insertions(+), 29 deletions(-)

