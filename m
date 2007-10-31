Return-Path: <linux-kernel-owner+w=401wt.eu-S1759780AbXJaPwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759780AbXJaPwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 11:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbXJaPvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 11:51:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214AbXJaPvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 11:51:51 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jens Axboe <jens.axboe@oracle.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@redhat.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Philippe Elie <phil.el@wanadoo.fr>,
       "William L. Irwin" <wli@holomorphy.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Lameter <christoph@lameter.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] Create kinst/ or ki/ directory ?
References: <20071029215138.GA4233@Krystal>
	<20071029154741.cb093f55.rdunlap@xenotime.net>
	<4726649A.5020605@garzik.org> <20071029230409.GB16943@Krystal>
	<472667F3.3000505@garzik.org> <20071030172442.GA4477@Krystal>
	<alpine.LFD.0.999.0710301044110.30120@woody.linux-foundation.org>
	<20071030185639.GA9077@Krystal>
	<alpine.LFD.0.999.0710301214300.30120@woody.linux-foundation.org>
	<20071030204043.GA13547@Krystal>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 31 Oct 2007 11:48:20 -0400
In-Reply-To: <20071030204043.GA13547@Krystal> (Mathieu Desnoyers's message of "Tue, 30 Oct 2007 16:40:44 -0400")
Message-ID: <y0mk5p3qo8r.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> [...]  SystemTAP, for instance, does it out of tree by keeping a
> separate list of address where kprobes must be installed. It does
> the job on a distribution kernel maintainer perspective (Redhat),
> since they freeze to a particular kernel version and update this
> list every time it breaks, but will always be a source of
> frustration for vanilla kernel users and kernel developers.

This misstates the details.  What systemtap has out-of-tree is a list
of kernel function names (and parameter names), not addresses.  This
list does change somewhat with kernel versions, but we generally keep
up.  We do test with vanilla kernels, and several non-RH distributors
test with their kernels.  It is a problem, but it is manageable.


> I think the best way to follow the code flow is to add markup in the
> code itself: it would follow the kernel HEAD and let each subsystem
> maintainer identify the key instrumentation sites of their
> subsystem.

Of course - when and where the dormant overheads are acceptable, and
where the maintainers are willing to commit to a long-term interface
(marker name/arguments).  Systemtap can connect to markers as well as
to kprobes and other event sources: mix & match based on what's
available in your particular kernel and what data/computation you
want.


> About extending on ptrace, I am sorry to say that this solution has
> the same downsides as kprobes: it is too slow for high performance
> applications, especially if turned on system-wide. [...]

Roland McGrath's ptrace-replacement (utrace) should help with this.


- FChE
