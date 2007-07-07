Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbXGGPq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbXGGPq5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 11:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbXGGPqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 11:46:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbXGGPqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 11:46:47 -0400
To: Adrian Bunk <bunk@stusta.de>
Cc: Dave Jones <davej@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] Scheduler profiling - Use immediate values
References: <20070703164046.645090494@polymtl.ca>
	<20070703164516.377240547@polymtl.ca>
	<20070703181151.GB5800@martell.zuzino.mipt.ru>
	<20070703185748.GA4047@Krystal>
	<20070705132120.8edbc1f3.akpm@linux-foundation.org>
	<p73vecx21um.fsf@bingen.suse.de> <468EBEB2.4070605@redhat.com>
	<20070706232843.GT3492@stusta.de> <20070706233827.GC13125@redhat.com>
	<20070707001008.GV3492@stusta.de>
From: fche@redhat.com (Frank Ch. Eigler)
Date: 07 Jul 2007 11:45:20 -0400
In-Reply-To: <20070707001008.GV3492@stusta.de>
Message-ID: <y0mvecwusj3.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk <bunk@stusta.de> writes:

> [...]
> profiling = debugging of performance problems

Indeed.

> My words were perhaps a bit sloppy, but profiling isn't part of
> normal operation and if people use a separate kernel for such
> purposes we don't need infrastructure for reducing performance
> penalties of enabled debug options.

Things are not so simple.  One might not know that one has a
performance problem until one tries some analysis tools.  Rebooting
into different kernels just to investigate does not work generally:
the erroneous phenomenon may have been short lived; the debug kernel,
being "only" for debugging, may not be well tested => sufficiently
trustworthy.

Your question asking for an actual performance impact of dormant hooks
is OTOH entirely legitimate.  It clearly depends on the placement of
those hooks and thus their encounter rate, more so than their
underlying technology (markers with whatever optimizations).  If the
cost is small enough, you will likely find that people will be willing
to pay a small fraction of average performance, in order to eke out
large gains when finding occasional e.g. algorithmic bugs.

- FChE
