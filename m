Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXLQTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXLQTUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:20:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbXLQTU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:20:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:51106 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbXLQTU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bHViyi8yJ08agkDyiAkhz/5OuMAEELLdVeZG9m3mXrLQ9/KAco8Y6WArwAPIpZHM0Sw96HwYGqj38LXhO/wPD7z1UOzhA1NRWadkLnG8qTeVn5yOG9EHolqr53d/12ww3vrNIVx3gATeESSb8UL1YDsxDy7MCYilFGIkBJPeCPU=
Subject: Re: FInal kprobes rollup patches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>, srinivasa@in.ibm.com,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       Rusty Lynch <rusty.lynch@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Keshavamurthy Anil S <anil.s.keshavamurthy@intel.com>
In-Reply-To: <20071217142235.GA21379@linux.vnet.ibm.com>
References: <1197708350.898.87.camel@brick> <20071215085015.GA9720@elte.hu>
	 <1197709442.898.97.camel@brick> <20071215131204.GE9720@elte.hu>
	 <20071217142235.GA21379@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 11:20:34 -0800
Message-Id: <1197919234.23402.5.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-12-17 at 19:52 +0530, Srikar Dronamraju wrote:
> * Ingo Molnar <mingo@elte.hu> [2007-12-15 14:12:04]:
> 
> 
> Hi Ingo, Harvey
> 
> In file include/asm-x86/kprobes_32.h
> typedef u8 kprobe_opcode_t;
> hence sizeof(kprobe_opcode_t) turns out to be 1.
> 
> Hence
> 
> memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
> is correct.
> 

OK, but this would be much clearer to adopt the X86_64 way, define
MAX_INSN_SIZE one smaller and make this line:

/* Copy original instruction plus space for 1 byte relative jump */
memcpy(p->ainsn.insn, p->addr, MAX_INSN_SIZE + sizeof(kprobe_opcode_t));

See the first patch of my cleanup work that unified MAX_INSN_SIZE
and you'll see why this jumped out.

Harvey

