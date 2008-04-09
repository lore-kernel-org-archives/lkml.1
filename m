Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYDII1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYDII1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYDII1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:27:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbYDII1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:27:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 0/2] x86 vdso 32-bit vdso-disabling fixes
X-Shopping-List: (1) Heretical consumers
   (2) Hideous laxative brunch
   (3) Pendulous arguments
Message-Id: <20080409082703.B805926F992@magilla.localdomain>
Date: Wed,  9 Apr 2008 01:27:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches together address two potential bugs when trying to
disable the 32-bit vDSO via sysctl or boot parameters (vdso32=0).

Currently, every 32-bit exec gets the vDSO mapped even if it's disabled
(the process just doesn't get told about it).  Because it's in fact
always there, the bug that patch 1/2 fixes cannot happen now.  With
patch 2/2, it won't be mapped at all when it's disabled, which is one
of the things that people might really want when they disable it (so
nothing they didn't ask for goes into their address space).

The 32-bit signal handler setup when SA_RESTORER is not used refers to
current->mm->context.vdso without regard to whether the vDSO has been
disabled when the process was exec'd.  Patch 1/2 fixes this not to use
it when it's null, which becomes possible after patch 2/2.  (This never
happens in normal use, because glibc's sigaction call uses SA_RESTORER
unless glibc detected the vDSO.)


Thanks,
Roland
