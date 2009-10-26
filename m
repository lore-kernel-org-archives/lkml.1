Return-Path: <linux-kernel-owner+w=401wt.eu-S1755854AbZJZMI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854AbZJZMI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 08:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbZJZMIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 08:08:25 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:41025 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbZJZMIY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 08:08:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KAgEVf6iYndq0NYADIpLk5jkl4FUsIZ/85oFb1hxC+YQRbV9fGlxPq5s0XuiOrYWE+
         uswlHT705Scon9AygLJylm6HTJ1SYlbkdVyKtrP/eFwRiFry+JcdBxVVfLUG+7qFmVHF
         zpFZRW/7m2EKaAacJ2gkoQtz1WVisExz+FZ6o=
MIME-Version: 1.0
In-Reply-To: <tip-fcd14b3203b538dca04a2b065c774c0b57863eec@git.kernel.org>
References: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
	 <tip-fcd14b3203b538dca04a2b065c774c0b57863eec@git.kernel.org>
Date: Mon, 26 Oct 2009 14:08:27 +0200
X-Google-Sender-Auth: 53e3ed62e002b602
Message-ID: <84144f020910260508n47ef067ci4adfd02cd3f87edd@mail.gmail.com>
Subject: Re: [tip:perf/core] perf tools, Alpha: Add Alpha support to perf.h
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
       mingo@elte.hu, mcree@orcon.net.nz
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, Oct 26, 2009 at 1:38 PM, tip-bot for Michael Cree
<mcree@orcon.net.nz> wrote:
> Commit-ID:  fcd14b3203b538dca04a2b065c774c0b57863eec
> Gitweb:     http://git.kernel.org/tip/fcd14b3203b538dca04a2b065c774c0b57863eec
> Author:     Michael Cree <mcree@orcon.net.nz>
> AuthorDate: Mon, 26 Oct 2009 21:32:06 +1300
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 26 Oct 2009 09:45:41 +0100
>
> perf tools, Alpha: Add Alpha support to perf.h
>
> For the perf tool the patch implements an Alpha specific section
> in the perf.h header file.
>
> Signed-off-by: Michael Cree <mcree@orcon.net.nz>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> LKML-Reference: <1256545926-6972-1-git-send-email-mcree@orcon.net.nz>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  tools/perf/perf.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 8cc4623..216bdb2 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -47,6 +47,12 @@
>  #define cpu_relax()    asm volatile("":::"memory")
>  #endif
>
> +#ifdef __alpha__
> +#include "../../arch/alpha/include/asm/unistd.h"
> +#define rmb()          asm volatile("mb" ::: "memory")
> +#define cpu_relax()    asm volatile("" ::: "memory")
> +#endif

OK, I'll bite. We tell userspace developers not to include kernel
headers. Why is it okay for perf to do it (especially for something
that's in asm)?

                        Pekka
