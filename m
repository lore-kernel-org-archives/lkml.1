Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbZHXWFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbZHXWFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZHXWFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:05:32 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:37401 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbZHXWFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:05:31 -0400
Date: Tue, 25 Aug 2009 07:05:32 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, fweisbec@gmail.com,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com, jistone@redhat.com,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 1/4] add NR_syscalls define for x86
Message-ID: <20090824220531.GA20832@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, fweisbec@gmail.com, mingo@elte.hu,
	laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
	mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
	mbligh@google.com, lizf@cn.fujitsu.com, jistone@redhat.com,
	tglx@linutronix.de, hpa@zytor.com
References: <cover.1251146512.git.jbaron@redhat.com> <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f33c0f96d198fccc3ddd9ff7f5334ff5cb42706.1251146513.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:40:14PM -0400, Jason Baron wrote:
> Add a NR_syscalls #define for x86. This is used in the syscall events tracing
> code. Todo: make it dynamic like x86_64
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> 
> ---
>  arch/x86/include/asm/unistd_32.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
> index 732a307..8deaada 100644
> --- a/arch/x86/include/asm/unistd_32.h
> +++ b/arch/x86/include/asm/unistd_32.h
> @@ -345,6 +345,8 @@
>  
>  #ifdef __KERNEL__
>  
> +#define NR_syscalls 337
> +
Syscalls start at 0 and end at 337, there are 338 syscalls, not 337.
Hence the off-by-1 that I initially reported. NR_syscalls is always the
last syscall + 1.
