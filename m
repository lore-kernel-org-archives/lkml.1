Return-Path: <linux-kernel-owner+w=401wt.eu-S1757503AbXLQOXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbXLQOXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 09:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbXLQOXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 09:23:15 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:48171 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbXLQOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 09:23:14 -0500
Date: Mon, 17 Dec 2007 19:52:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
Subject: Re: FInal kprobes rollup patches
Message-ID: <20071217142235.GA21379@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu> <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20071215131204.GE9720@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2007-12-15 14:12:04]:


Hi Ingo, Harvey

In file include/asm-x86/kprobes_32.h
typedef u8 kprobe_opcode_t;
hence sizeof(kprobe_opcode_t) turns out to be 1.

Hence

memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
is correct.

--
Regards
Srikar




> 
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > If you compare this memcpy from arch_prepare_kprobe in 32/64 bit I'm 
> > almost sure the X86_32 version should be
> > 
> > ... + sizeof(kprobe_opcode_t)
> > 
> > not
> > 
> > ... * sizeof(kprobe_opcode_t)
> 
> good point. I've Cc:-ed the top authors of kprobes.c. Could anyone 
> confirm (or deny) that Harvey found a real kprobes bug here?
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
