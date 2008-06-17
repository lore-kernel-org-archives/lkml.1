Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYFQNWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYFQNWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 09:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbYFQNWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 09:22:06 -0400
Received: from [194.117.236.238] ([194.117.236.238]:56272 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbYFQNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 09:22:04 -0400
Date: Tue, 17 Jun 2008 16:21:28 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when reading
 across CPUs.
Message-ID: <20080617162128.634ea287@linux360.ro>
In-Reply-To: <20080617125543.GA8696@Krystal>
References: <20080613040958.4f52ee29@linux360.ro>
	<1213417601.8237.37.camel@charm-linux>
	<20080614181103.17617db1@linux360.ro>
	<20080616122249.GB18561@Krystal>
	<20080616162212.27a8c119@linux360.ro>
	<20080616164609.GM20851@kernel.dk>
	<84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com>
	<20080616182843.GS20851@kernel.dk>
	<20080617153934.59a7c7ee@linux360.ro>
	<20080617125543.GA8696@Krystal>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2008 08:55:44 -0400
Mathieu Desnoyers <compudj@krystal.dyndns.org> wrote:

> How about not changing the code, not providing a safe version of
> relay_write, but document its use and what kind of locking the
> in-kernel user must provide ?
> 
> Mathieu

I would have agreed with you if this was about some other kernel
function. But having the user provide locking means more than just
bracing writes with spinlocks. Essentially, one also needs to duplicate
relay_file_read() and relay_file_read_subbufs(), thus having to know
relay's internals.

When I do this, I'll split my changes into two parts, with the first just
documenting as you said. Anyway, the non-affine versions are low
priority for me right now.

BTW, did you recieve or took a look at the buffer-only channels patch
series, the one with CPU hotplug support? Sorry for being impatient,
but that early initcall is really core stuff and I'd like a review. :-)


	Eduard
