Return-Path: <linux-kernel-owner+w=401wt.eu-S1161291AbXDKXAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161291AbXDKXAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:00:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161401AbXDKXAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:00:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161291AbXDKW7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:59:46 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       systemtap@sources.redhat.com
Subject: Re: [PATCH] markers-linker-generic
References: <20070410223658.GC7092@Krystal>
	<20070411074414.GC3752@flint.arm.linux.org.uk>
	<20070411175110.GA30879@Krystal>
	<20070411110240.537ee25d.akpm@linux-foundation.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 11 Apr 2007 18:58:50 -0400
In-Reply-To: <20070411110240.537ee25d.akpm@linux-foundation.org>
Message-ID: <y0my7kyldqt.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Andrew Morton <akpm@linux-foundation.org> writes:

> [...]  I am told that the systemtap developers plan to (or are)
> using this infrastructure.

Indeed.

> If correct: what is their reason for preferring it over kprobes?
> [...]

It's not a preference - it's more of a supplement.  It's helpful when
some combination of such factors exists:

- kprobe int3-fault dispatching overhead orders of magnitude too high
- fault dispatching not permissible in some areas
- local context variables not easily retrievable via dwarf information
- dwarf information not available at all
- costs of permanently placed but passive marker acceptable

>From systemtap's point of view, instrumentation hooked to markers,
kprobes, and other facilities like timers, coexist just fine.  A
greater number of probe-able event sources makes for a richer tool.


- FChE
