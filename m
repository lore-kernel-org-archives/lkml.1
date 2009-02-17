Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZBQIc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZBQIc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 03:32:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZBQIcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 03:32:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:55438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZBQIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 03:32:18 -0500
Subject: Re: irq-disabled vs vmap vs text_poke
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>
In-Reply-To: <20090217030353.GA31504@wotan.suse.de>
References: <20090213141839.GA31922@Krystal> <4995A0B7.1030705@redhat.com>
	 <20090213165555.GA4684@Krystal> <4995B88C.2090900@redhat.com>
	 <20090213185725.GC7124@Krystal> <4995E925.3080506@redhat.com>
	 <4999808B.5080505@redhat.com> <20090216153145.GB19182@wotan.suse.de>
	 <20090216172441.GA12576@Krystal> <499A1A43.6000009@redhat.com>
	 <20090217030353.GA31504@wotan.suse.de>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 09:31:56 +0100
Message-Id: <1234859516.4744.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 04:03 +0100, Nick Piggin wrote:

> It is not a bad idea, but I don't think it quite goes far enough.
> IMO we should reserve 2 pages of virtual memory for each CPU, and
> then do the mapping/unmapping without locking, and with another
> variant of unmap_kernel_range that does not do the global TLB
> flush.

A bit like kmap_atomic() except for 2 pages and !highmem. Should work.

