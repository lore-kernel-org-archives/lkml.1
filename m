Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab0CCKHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 05:07:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:36214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab0CCKHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 05:07:41 -0500
Subject: Re: [RFC][PATCH 2/3] perf: Take a hot regs snapshot for trace
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
References: <1267599302-2886-1-git-send-regression-fweisbec@gmail.com>
	 <1267599302-2886-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 09:38:49 +0100
Message-ID: <1267605529.25158.75.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 07:55 +0100, Frederic Weisbecker wrote:
>  /*
> + * Hot regs snapshot support -- arch specific
> + * This needs to be a macro because we want the current
> + * frame pointer.
> + */
> +#ifndef PERF_SAVE_REGS
> +#define PERF_SAVE_REGS(regs)   memset(regs, 0, sizeof(*regs));
> +#endif

It would be nice to have the fallback at least set the current or
calling IP, now you've basically wrecked stuff for everything !x86.

