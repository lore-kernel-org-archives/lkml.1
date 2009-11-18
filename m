Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbZKRXIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbZKRXIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZKRXIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:08:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbZKRXIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:08:18 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
X-Fcc: ~/Mail/linus
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, rth@redhat.com,
       mhiramat@redhat.com
Subject: Re: [RFC PATCH 0/6] jump label v3
In-Reply-To: H. Peter Anvin's message of  Wednesday, 18 November 2009 14:51:45 -0800 <4B047A81.3060104@zytor.com>
References: <cover.1258580048.git.jbaron@redhat.com>
	<4B047A81.3060104@zytor.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091118230758.0C49A9D5@magilla.sf.frob.com>
Date: Wed, 18 Nov 2009 15:07:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 67 66 8D 74 00 (lea si,[si+0]) should work as a 32-bit atomic NOP.  It's
> not necessarily the fastest, though (I have no data on that.)
> Similarly, 66 66 66 66 90 should also work.

We should get all the knowledge like that stored in places like the
Kconfig.cpu comments near X86_P6_NOP and/or asm/nops.h macros and comments.

Let's have an ASM_ATOMIC_NOP5 macro in asm/nops.h?  I've lost track of the
variants, and I'll leave that to you all who are close to the chip people.

I can't tell if it's the case that there will be kernel configurations
where there is one known-safe choice but a different choice that's optimal
if CPU model checks pass.  If so, we could compile in the safe choice and
then mass-change to the optimal choice at boot time.  (i.e. like the
alternatives support, but we don't really need to use that too since we
already have another dedicated table of all the PC addresses to touch.)


Thanks,
Roland
