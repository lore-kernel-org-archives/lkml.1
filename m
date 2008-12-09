Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbYLIKE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbYLIKE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 05:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbYLIKEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 05:04:51 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:47896 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYLIKEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:04:50 -0500
Message-Id: <493E50DE.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 09 Dec 2008 10:05:02 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>, <tglx@linutronix.de>,
       <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: x86-64: __pa_symbol() vs. __pa()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can any of you recall the reason for the comment accompanying the
__pa_symbol() definition:

/* __pa_symbol should be used for C visible symbols.
   This seems to be the official gcc blessed way to do such arithmetic. */

To me this rather sounds like a compiler problem, and if it indeed
exists then at least a few incorrect use have slipped in recently:
- arch/x86/mm/ioremap.c passes bm_pte to __pa()
- arch/x86/mm/pageattr.c passes _text and __{start,end}_rodata
  to __pa()
- arch/x86/mm/pgtable.c and arch/x86/xen/smp.c pass
  swapper_pg_dir to __pa()
- arch/x86/xen/enlighten passes level3_user_vsyscall to __pa()
This is only the set where x86-64 (which prior to the merge had
above comment already) is affected, i386 would have a few more.

What would be particularly problematic is the potential indirect use
of __pa(), e.g. through Xen's virt_to_{machine,bus}() as well as
the use in common code (e.g. kernel/kexec.c).

Thanks, Jan

