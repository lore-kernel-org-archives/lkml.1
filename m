Return-Path: <linux-kernel-owner+w=401wt.eu-S1764788AbYDOMCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764788AbYDOMCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761275AbYDOMCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:02:33 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:36588 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYDOMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:02:33 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: prasad@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       mathieu.desnoyers@polymtl.ca
In-Reply-To: <20080415115314.GA6975@in.ibm.com>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 14:02:22 +0200
Message-Id: <1208260942.6395.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-15 at 17:23 +0530, K. Prasad wrote:

> +	trace_mark(futex_wait_called, "uaddr:%p fshared:%p val:%u "
> +			"abs_time:%p bitset:%d",
> +			uaddr, fshared, val, abs_time, bitset);

This is some seriuosly ugly looking gunk, why would we want stuff like
that scattered across the code?

What is wrong with a few simple hooks like:

  trace_futex_wait(uaddr, fshares, val, abs_time, bitset);

and then deal with that.

Also, you seem to expose way too much futex internals; do you really
need that? People will go use this marker crap like ABI and further
restrain us from changing the code.

/me unhappy.



