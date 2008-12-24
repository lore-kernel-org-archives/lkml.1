Return-Path: <linux-kernel-owner+w=401wt.eu-S1752511AbYLXPP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbYLXPP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbYLXPPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:15:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35922 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbYLXPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:15:49 -0500
Date: Wed, 24 Dec 2008 10:15:46 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/ftrace: don't trace on early stage of a
 secondary cpu boot
In-Reply-To: <49524BD5.9010106@gmail.com>
Message-ID: <alpine.DEB.1.10.0812241006010.30121@gandalf.stny.rr.com>
References: <49524BD5.9010106@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cool, so the CFLAGS_REMOVE solution worked.

I'm the last one to criticize someones language, especially when it is not 
their native tongue. The closest language outside of English that I know 
is German, and I would do horrible if I had to write this in German. Heck, 
my English sucks too ;-)

But since this is going to be a public record of what you changed, it 
should be a bit more clear.

On Wed, 24 Dec 2008, Frederic Weisbecker wrote:

> Impact: fix a crash/hard-reboot while enabling cpu on runtime
> 
> On some archs, the boot of a secondary cpu can have an early fragile state.
> On x86-64, the pda is not initialized on the first stage of a cpu boot but

s/on the first/in the first/

> it is needed to get the cpu number and the current task pointer. These datas

s/These datas are/This data is/

> are needed during tracing. As they were dereferenced at this stage, we got a
> crash while turning on a cpu on runtime while tracing.

"we got a crash while tracing a cpu being enabled at runtime"

> 
> Some other archs like ia64 can have such kind of issue too.
> 
> Changes on v2:
> 
> We drop the previous solution of a per-arch called function to guess the current state

s/drop/dropped/

> of a cpu. That could make slow the tracing.

"That could slow down the tracing."

> This patch just drop the -pg flag on arch/x86/kernel/cpu/common.c where

"This patch removes the -pg flag..."

> live the low level cpu boot functions, and on start_secondary() and a helper

"where the low level cpu boot functions exist"

s/, and on/, on/

> function used at this stage.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Again, I'm still impressed by your ability to communicate in a language 
other than your own. And perhaps my corrections are incorrect too ;-)

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

