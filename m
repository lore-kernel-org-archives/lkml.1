Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZC3QQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZC3QQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:16:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZC3QQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:16:13 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:47728 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZC3QQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=tCQNlkdfzL/6OSNXvfcAL/B+IDoYJiucEBa7yyAXNuWPlh9xtk8xKzBKJGiZU0DsLk
         qRvzpTVkyJBkqLKH7IJEHguG4Dq3CrUMixB4/EMGmJVoh3tRHhW+/81h45SE7uwdzcrF
         Opgd4d6rekz01dnExH6d7eJvpGj29x3Q8pfMg=
Date: Mon, 30 Mar 2009 18:16:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Teoh <htmldeveloper@gmail.com>, Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: compilation error in linus git tree
Message-ID: <20090330161606.GA5979@nowhere>
References: <804dabb00903300901n37e54577ka3000c106a937950@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <804dabb00903300901n37e54577ka3000c106a937950@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, Mar 30, 2009 at 12:01:59PM -0400, Peter Teoh wrote:
> just git pulled and compiled with the following errors:
> 
>   CC [M]  arch/x86/kernel/cpu/cpufreq/speedstep-lib.o
>   CC [M]  arch/x86/kernel/cpu/cpufreq/p4-clockmod.o
> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c: In function ‘cpufreq_p4_cpu_init’:
> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c:232: error: implicit
> declaration of function ‘recalibrate_cpu_khz’
> make[3]: *** [arch/x86/kernel/cpu/cpufreq/p4-clockmod.o] Error 1
> make[2]: *** [arch/x86/kernel/cpu/cpufreq] Error 2
> make[1]: *** [arch/x86/kernel/cpu] Error 2
> make: *** [arch/x86/kernel] Error 2
> 
> not sure where is the best place to put this, but the error is resolved via
> 
> extern int recalibrate_cpu_khz(void);
>
> inside the file:
> 
> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c


Indeed but its prototype is already defined in asm/timer.h
This is a missing include, can you tell me if the patch below fixes
your problem?

Thanks,
Frederic.


--

>From c4a2eec69fa98b6cdb060c593a720099878bf854 Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 30 Mar 2009 18:08:37 +0200
Subject: [PATCH] x86: fix missing include asm/timer.h in p4-clockmod.c

Impact: fix build error

arch/x86/kernel/cpu/cpufreq/p4-clockmod.c lacks the prototype
of recalibrate_cpu_khz(), we need to include asm/timer.h

Reported-by: Peter Teoh <htmldeveloper@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index d8341d1..aca3f11 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -31,6 +31,7 @@
 #include <asm/processor.h>
 #include <asm/msr.h>
 #include <asm/timex.h>
+#include <asm/timer.h>
 
 #include "speedstep-lib.h"
 
-- 
1.6.1


