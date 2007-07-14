Return-Path: <linux-kernel-owner+w=401wt.eu-S1760460AbXGNKta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760460AbXGNKta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 06:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXGNKtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 06:49:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57543 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbXGNKtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 06:49:21 -0400
Date: Sat, 14 Jul 2007 11:49:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       davem@davemloft.net
Subject: Re: [patch 1/8] Kprobes - do not use kprobes mutex in arch code
Message-ID: <20070714104914.GB7358@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	prasanna@in.ibm.com, ananth@in.ibm.com,
	anil.s.keshavamurthy@intel.com, davem@davemloft.net
References: <20070714012133.612727310@polymtl.ca> <20070714012411.262873138@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070714012411.262873138@polymtl.ca>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 09:21:34PM -0400, Mathieu Desnoyers wrote:
> Remove the kprobes mutex from kprobes.h, since it does not belong there. Also
> remove all use of this mutex in the architecture specific code, replacing it by
> a proper mutex lock/unlock in the architecture agnostic code.

This is not very nice for avr32/sparc64 which have a noop arch_remove_kprobe
and now need to take a mutex to do nothing.  Maybe you can find a nice
way to avoid that?

Except for this issue making kprobes_mutex static to kprobes.c sounds like
a good improvement.

