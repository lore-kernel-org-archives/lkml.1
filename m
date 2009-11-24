Return-Path: <linux-kernel-owner+w=401wt.eu-S933473AbZKXQUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933473AbZKXQUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758113AbZKXQUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:20:19 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:51570 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758095AbZKXQUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:20:18 -0500
Message-ID: <4B0C07C2.7090608@us.ibm.com>
Date: Tue, 24 Nov 2009 08:20:18 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Michel Lespinasse <walken@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/3] perf bench: Add wrappers for atomic operation of
 GCC
References: <20091118033741.GB23808@google.com> <1259073555-7312-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <1259073555-7312-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake wrote:
> This patch adds new file util/include/asm/atomic.h.
> It contains wrappers for atomic operation of GCC,
> I think this is useful not only for 'perf bench',
> but also for entire of perf command.
> 
> This patch adds new typedefed struct 'atomic_t'.
> I know new typedef is not a thing to welcome,
> but I believe that atomic_t is worth to typedef
> because it is much general.
> 
> I borrowed this file from Darren Hart's futextest.
> http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git

Hi Hitoshi-san,

I took the gcc built-ins approach for futextest.h because I didn't want 
the hassle of maintaining per-arch asm files. Since perf is already in 
the kernel source, I wonder if you could leverage the already existing 
kernel atomic code? See Documentation/atomic_ops.txt.

> 
> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
> Cc: Michel Lespinasse <walken@google.com>
> Cc: Darren Hart <dvhltc@us.ibm.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/util/include/asm/atomic.h |   91 ++++++++++++++++++++++++++++++++++
>  1 files changed, 91 insertions(+), 0 deletions(-)
>  create mode 100644 tools/perf/util/include/asm/atomic.h
> 
> diff --git a/tools/perf/util/include/asm/atomic.h b/tools/perf/util/include/asm/atomic.h
> new file mode 100644
> index 0000000..1cef451
> --- /dev/null
> +++ b/tools/perf/util/include/asm/atomic.h
> @@ -0,0 +1,91 @@
> +/******************************************************************************
> + *
> + *   Copyright B) International Business Machines  Corp., 2009

B) should be © (or (C) at the very least), I'm guessing character set issue?

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
