Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZD2HdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZD2HdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZD2HdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:33:06 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:51127 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbZD2HdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:33:05 -0400
Date: Wed, 29 Apr 2009 09:35:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH/RFT 0/13] x86: unify vmlinux.lds
Message-ID: <20090429073510.GA26386@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patchset is on top of the x86/kbuild branch of tip.
It unifies vmlinux.lds so we end up with a single file.

The patchset has been build tested on 32bit and 64 bit but has
not been boot tested. (Lacking time/resources atm).

The steps were made minimal to make it simpler to track regressions
using bisect (if any) and to make review easier.

The unified vmlinux.lds shows some questionable differences
between 32 bit and 64 bit.

o  64 bit uses PHDRS more extensively than 32 bit. Could they be the same?

o  _stext does not cover all text for 32 bit - a bug? For 64b bit it does.
   It is only the .code16 wakeup stuff that is not covered but anyway.

o  _edata covers much more on 32 bit

o  The nosave stuff differs (but that is due to the PHDRS stuff anyway)

o  Different alignmnet requirements in several spots

o  All the stuff added to support relocable kernels

Please test/review.

This patchset will conflict with Tim's work but the conflicts should
be simple to fix. Lets tackle that later.

	Sam

 arch/x86/kernel/head_32.S        |    7 -
 arch/x86/kernel/vmlinux.lds.S    |  421 +++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/vmlinux_32.lds.S |  229 ---------------------
 arch/x86/kernel/vmlinux_64.lds.S |  336 ------------------------------
 4 files changed, 419 insertions(+), 574 deletions(-)

Sam Ravnborg (13):
      x86: beautify vmlinux_32.lds.S
      x86, vmlinux.lds: unify header/footer
      x86, vmlinux.lds: unify PHDRS
      x86, vmlinux.lds: unify start/end of SECTIONS
      x86, vmlinux.lds: unify .text output sections
      x86, vmlinux.lds: unify exceptiontable
      x86, vmlinux.lds: unify data output sections
      x86, vmlinux.lds: move vsyscall output sections
      x86, vmlinux.lds: unify first part of initdata
      x86, vmlinux.lds: unify parainstructions
      x86, vmlinux.lds: unify .exit.* and .init.ramfs
      x86, vmlinux.lds: unify percpu
      x86, vmlinux.lds: unify remaining parts


