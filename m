Return-Path: <linux-kernel-owner+w=401wt.eu-S965825AbXCTSvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965825AbXCTSvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 14:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965910AbXCTSvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 14:51:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965825AbXCTSvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 14:51:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/utrace
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm2
In-Reply-To: Andrew Morton's message of  Monday, 19 March 2007 17:39:15 -0700 <20070319173915.d3f99dee.akpm@linux-foundation.org>
X-Zippy-Says: ..  my NOSE is NUMB!
Message-Id: <20070320185100.E456818004F@magilla.sf.frob.com>
Date: Tue, 20 Mar 2007 11:51:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Previously <linux/ptrace.h> had #include <linux/sched.h>, and mine just had
"struct task_struct;" instead for its forward references.  asm-x86_64/elf.h
uses current->field in the ELF_CORE_COPY_REGS macro, expanded in
linux/elfcore.h in elf_core_copy_regs.  So it needs sched.h but is no
longer getting it implicitly.  Since current appears in asm-x86_64/elf.h,
there is some logic to having #include <linux/sched.h> explicit there
instead of somewhere else.  But to reduce undue perturbation, I'll just
change my patch to preserve the #include in linux/ptrace.h instead.


Thanks,
Roland
