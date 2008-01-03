Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYACQC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYACQC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 11:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbYACQCV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 11:02:21 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:47226 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYACQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 11:02:19 -0500
Subject: Re: [RFC PATCH 01/11] Add basic support for gcc profiler
	instrumentation
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080103072226.776141236@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
	 <20080103072226.776141236@goodmis.org>
Content-Type: text/plain
Date: Thu, 03 Jan 2008 08:01:59 -0800
Message-Id: <1199376119.5160.39.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-03 at 02:16 -0500, Steven Rostedt wrote:
> Index: linux-compile.git/Makefile
> ===================================================================
> --- linux-compile.git.orig/Makefile     2008-01-03 01:02:28.000000000 -0500
> +++ linux-compile.git/Makefile  2008-01-03 01:02:39.000000000 -0500
> @@ -509,11 +509,15 @@ endif
>  
>  include $(srctree)/arch/$(SRCARCH)/Makefile
>  
> +ifdef CONFIG_MCOUNT
> +KBUILD_CFLAGS  += -pg -fno-omit-frame-pointer -fno-optimize-sibling-calls
> +else
>  ifdef CONFIG_FRAME_POINTER
>  KBUILD_CFLAGS  += -fno-omit-frame-pointer -fno-optimize-sibling-calls
>  else
>  KBUILD_CFLAGS  += -fomit-frame-pointer
>  endif
> +endif
>  
>  ifdef CONFIG_DEBUG_INFO
>  KBUILD_CFLAGS  += -g

I'd much prefer if you used -finstrument-function since it's already
architecture independent .. It was suggested not too long ago.. There is
also another tracing patchset that is similar to this one which uses it
(KFT)..

Daniel

