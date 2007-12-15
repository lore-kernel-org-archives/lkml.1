Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbXLOJE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbXLOJE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 04:04:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbXLOJEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 04:04:08 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:54123 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbXLOJEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 04:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=cMmeFntZ/0AZIwn4fQAlpQUNJ39X99Ei1TXJjlu0yMAF+N3+kanFiv8kbn/MQE+OQO5dy3jdaNSbqwRsoMoRdP0AkDPQLD7uMcRQgh2Nl3XO+cVMgrzCZGxhWbotDRHiSjAm9Rf497HBphEWmPBB/WJEDL0mcBvJZlGnO6d7t8A=
Subject: Re: FInal kprobes rollup patches
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071215085015.GA9720@elte.hu>
References: <1197708350.898.87.camel@brick>  <20071215085015.GA9720@elte.hu>
Content-Type: text/plain
Date: Sat, 15 Dec 2007 01:04:02 -0800
Message-Id: <1197709442.898.97.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-15 at 09:50 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Further unification work.  There is a possible behavior change on 
> > X86_32 here.
> > 
> > is_IF_modifier(p->opcode)
> > 
> > to
> > 
> > is_IF_modifier(p->ainsn.insn)
> > 
> > Which should be equivalent, but is not purely cosmetic as the rest of 
> > the unification so far.
> 
> hm, could you split this into two, the pure-equivalence and the 
> possibly-modifying patch? (that way any potential breakage becomes 
> bisectable) Same end result, just two commits instead of one.
> 
Sure, I'll go back through and see if the series can be cleaned up a bit
as well as expand the commit message a little bit.

> also, did you manage to run/test kprobes (on 32-bit or 64-bit x86), and 
> it worked fine?
> 

Sorry, I should have predicated the whole series with RFC.  Currently
this is compile-tested only.  There is only the one patch that has
any behavioral change.  I believe the series also pointed out an
existing bug in the 32-bit version...which I've preserved but will
note in the commit messages in the respun series.

In case you're interested, from the patch which unifies the definition
of MAX_INSTRUCTION_SIZE:

memcpy(p->ainsn.insn, p->addr, (MAX_INSN_SIZE + 1) *
sizeof(kprobe_opcode_t));

If you compare this memcpy from arch_prepare_kprobe in 32/64 bit I'm
almost sure the X86_32 version should be

... + sizeof(kprobe_opcode_t)

not

... * sizeof(kprobe_opcode_t)

Cheers,

Harvey

