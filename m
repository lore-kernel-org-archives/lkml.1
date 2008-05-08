Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbYEHGvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbYEHGvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 02:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbYEHGvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 02:51:09 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54067 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbYEHGvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 02:51:06 -0400
Message-ID: <20080508025101.a9177nongg4kgg4g@imap.linux.ibm.com>
Date: Thu,  8 May 2008 02:51:01 -0400
From: Anoop <acv@linux.vnet.ibm.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org,
       mtk.manpages@googlemail.com
Subject: Re: ptrace PTRACE_PEEKUSER behavior
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Quoting Roland McGrath <roland@redhat.com>:

> 'struct user' is really a virtual structure layout, and never exists
> anywhere as an actual struct.  It's really just defining the argument
> values that can be used in PEEKUSR/POKEUSR calls.

But the powerpc ptrace code returns the FPRs & FPSCR though they are  
not part of user struct.

CHECK_FULL_REGS(child->thread.regs);
if (index < PT_FPR0) {
		tmp = ptrace_get_reg(child, (int) index);
} else { <=============
		flush_fp_to_thread(child);
		tmp = ((unsigned long *)child->thread.fpr)[index - PT_FPR0];
}
ret = put_user(tmp,(unsigned long __user *) data);

Does this mandate inclusion of floating point set in powerpc user struct?

Regards,
- Anoop

