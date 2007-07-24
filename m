Return-Path: <linux-kernel-owner+w=401wt.eu-S1764112AbXGXPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764112AbXGXPFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXGXPF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:05:27 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:32979 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbXGXPF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:sender;
        b=AFMsH/RN+o7WwJ6DI+I4U7KcCCnfC0cfBwC0TgkHBTjigRHMmpL3cbJFhkKGUeBSRMP56Jl3ssXEFtwI+ibcT94MGJJqjHZqpOrGs+yX0o6kpme1QqhSslU/jwPR+QCY4kCUiGEx6Mnnh7DrlUrX62b2+N8uHOVHXoeBO89YXA8=
Date: Tue, 24 Jul 2007 17:02:01 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.23-rc1-rt0
Message-ID: <20070724150201.GA27113@slug>
References: <20070724121227.GA18670@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724121227.GA18670@elte.hu>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:12:27PM +0200, Ingo Molnar wrote:
> i've released the v2.6.23-rc1-rt0 kernel, which can be downloaded from 
> the usual place:
>  
>    http://redhat.com/~mingo/realtime-preempt/
Hi Ingo,

  CC      kernel/latency_hist.o
  kernel/latency_hist.c: In function 'u64_div':
  kernel/latency_hist.c:54: error: implicit declaration of function 'do_div'
  make[1]: *** [kernel/latency_hist.o] Error 1
  make: *** [kernel] Error 2

This was needed to compile rt0 with LATENCY_TRACE on i386:

Add asm/div64.h header to define do_div()

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

--- kernel/latency_hist..ori	2007-07-24 16:04:20.000000000 +0200
+++ kernel/latency_hist.c	2007-07-24 16:04:50.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/percpu.h>
 #include <linux/latency_hist.h>
 #include <asm/atomic.h>
+#include <asm/div64.h>
 
 typedef struct hist_data_struct {
 	atomic_t hist_mode; /* 0 log, 1 don't log */
