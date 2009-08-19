Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbZHSM4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbZHSM4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 08:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751709AbZHSM4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 08:56:30 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:54591 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbZHSM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 08:56:28 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 4/4][RFC] perf_counter: Allow sharing of output channels
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       stephane eranian <eranian@googlemail.com>
In-Reply-To: <19083.61914.571806.395197@cargo.ozlabs.ibm.com>
References: <20090819091823.916851355@chello.nl>
	 <20090819092023.980284148@chello.nl>
	 <19083.61914.571806.395197@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 19 Aug 2009 14:56:26 +0200
Message-Id: <1250686586.8282.12.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-19 at 22:36 +1000, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > Provide the ability to configure a counter to send its output to
> > another (already existing) counter's output stream.
> 
> What sort of thing might this be useful for?

Some people complained that its tedious to mmap() for every counter and
would like to share the mmap() output buffer between counters.

This saves on address space and mlock budget and I guess fd management
logic.

As long as you're not mixing counters for different tasks/cpus there
should be no performance penalty, but even if you do that it might work
well enough on slow samples/small systems..

> Does this only apply to sampling counters?

Yeah, everything that would otherwise go through the mmap() buffer.

I'm not sure there's anything to be done about the read(2) thing.

