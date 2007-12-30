Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbXL3IJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbXL3IJX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 03:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750735AbXL3IJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 03:09:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbXL3IJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 03:09:14 -0500
Message-ID: <47775062.4070300@redhat.com>
Date: Sun, 30 Dec 2007 03:01:38 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Introduce REX prefix helper for kprobes
References: <1198466795.6323.12.camel@brick> <47773C2D.8070600@redhat.com> <47774314.9080406@zytor.com>
In-Reply-To: <47774314.9080406@zytor.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

H. Peter Anvin wrote:
>> Could you use a macro same as the stack_addr() macro, like as below?
>>
>> #defile is_REX_prefix(insn) ((insn & 0xf0) == 0x40))
>>
>> This is just a bit checker, so I think a macro is better to do that.
>>
> 
> Why is a macro better than an inline, and why the odd mIXed case?

I thought we can use macro because it just check a bit mask.
And if we use this as a macro, it will be defined in #ifdef block at
the top of kprobes.c. It is simple in this case.
I know the inline is better than the macro, it can check the type of
arguments.
If you would like to use inline, how about this?

---
(in case of CONFIG_X86_64)
static inline int is_rex_prefix(int op)
{
	return ((op & 0xf0) == 0x40);
}

(in case of CONFIG_X86_32)
#define is_rex_prefix(op) (0)
---

About the name, I just used the previous inline function name.

Thank you,

> 
> 	-hpa

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

