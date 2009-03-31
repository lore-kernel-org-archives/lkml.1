Return-Path: <linux-kernel-owner+w=401wt.eu-S1762313AbZCaGdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762313AbZCaGdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758034AbZCaGdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:33:03 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:60481 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZCaGdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:33:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nZGhLy0eyT71yVBeeLUelIcdcUM9cma6QpPsadknPOWL6u9oXfBfyGSmReH4+0WRC9
         GH4xRj4Yntd22k99Gev3Cve+60I7HWb2jQXrEgeYuh7v9C6W83m1U4PC+fp4VfAWm3kE
         MPdja+481Jq9SAXg9Jqvg3OF82CF369M4Kl3g=
MIME-Version: 1.0
In-Reply-To: <20090330161606.GA5979@nowhere>
References: <804dabb00903300901n37e54577ka3000c106a937950@mail.gmail.com>
	 <20090330161606.GA5979@nowhere>
Date: Tue, 31 Mar 2009 14:32:58 +0800
Message-ID: <804dabb00903302332m34b4f4fbt54df1a3da93d9425@mail.gmail.com>
Subject: Re: compilation error in linus git tree
From: Peter Teoh <htmldeveloper@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes it worked, although the line number is slightly different for
linus git tree.

The modified version is as follows.   Thanks!!!!

On Tue, Mar 31, 2009 at 12:16 AM, Frederic Weisbecker
<fweisbec@gmail.com> wrote:
> Hi,
>
>
> On Mon, Mar 30, 2009 at 12:01:59PM -0400, Peter Teoh wrote:
>> just git pulled and compiled with the following errors:
>>
>>   CC [M]  arch/x86/kernel/cpu/cpufreq/speedstep-lib.o
>>   CC [M]  arch/x86/kernel/cpu/cpufreq/p4-clockmod.o
>> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c: In function ‘cpufreq_p4_cpu_init’:
>> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c:232: error: implicit
>> declaration of function ‘recalibrate_cpu_khz’
>> make[3]: *** [arch/x86/kernel/cpu/cpufreq/p4-clockmod.o] Error 1
>> make[2]: *** [arch/x86/kernel/cpu/cpufreq] Error 2
>> make[1]: *** [arch/x86/kernel/cpu] Error 2
>> make: *** [arch/x86/kernel] Error 2
>>
>> not sure where is the best place to put this, but the error is resolved via
>>
>> extern int recalibrate_cpu_khz(void);
>>
>> inside the file:
>>
>> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
>
>
> Indeed but its prototype is already defined in asm/timer.h
> This is a missing include, can you tell me if the patch below fixes
> your problem?
>
> Thanks,
> Frederic.
>
>
> --
>
> From c4a2eec69fa98b6cdb060c593a720099878bf854 Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 30 Mar 2009 18:08:37 +0200
> Subject: [PATCH] x86: fix missing include asm/timer.h in p4-clockmod.c
>
> Impact: fix build error
>
> arch/x86/kernel/cpu/cpufreq/p4-clockmod.c lacks the prototype
> of recalibrate_cpu_khz(), we need to include asm/timer.h
>
> Reported-by: Peter Teoh <htmldeveloper@gmail.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/p4-clockmod.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
> index d8341d1..aca3f11 100644
> --- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
> +++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
> @@ -31,6 +31,7 @@
>  #include <asm/processor.h>
>  #include <asm/msr.h>
>  #include <asm/timex.h>
> +#include <asm/timer.h>
>
>  #include "speedstep-lib.h"
>
> --
> 1.6.1
>
>
>

Reported-by: Peter Teoh <htmldeveloper@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpu
index 41ed949..fd8ec01 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 #include <linux/cpumask.h>
 #include <linux/timex.h>
+#include <linux/timer.h>

 #include <asm/processor.h>
 #include <asm/msr.h>




-- 
Regards,
Peter Teoh
