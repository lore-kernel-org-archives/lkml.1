Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbXKXENw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbXKXENw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 23:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXKXENo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 23:13:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbXKXENo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 23:13:44 -0500
Date: Sat, 24 Nov 2007 04:13:24 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Milan Broz <mbroz@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2-mm1: kcryptd vs lockdep
Message-ID: <20071124041324.GE22843@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Torsten Kaiser <just.for.lkml@googlemail.com>,
	Milan Broz <mbroz@redhat.com>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <64bb37e0711182323v1e2a1341tfc7f20df771b988@mail.gmail.com> <20071119075627.GB28432@elte.hu> <64bb37e0711191134l6dac07a2ie3b4258c43e1f1f0@mail.gmail.com> <4741F97D.6090808@redhat.com> <64bb37e0711231442y7603366aib9642eab97e5be6b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64bb37e0711231442y7603366aib9642eab97e5be6b@mail.gmail.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 11:42:36PM +0100, Torsten Kaiser wrote:
> Before the cleanup *all* calls to crypt_dec_pending() was via crypt_endio().
> Now there is an additional call to crypt_dec_pending() to balance the
> additional ref placed into crypt_write_io_process(). And that one is
> not called from whatever context/thread cleans up after
> make_generic_request, but directly in the context/thread of the caller
> of crypt_write_io_process(), and that is kcryptd.
 
Please do look at the latest patches (always at
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/series.html )
where you'll see I've already disentangled the mess of functions
and given them more understandable names, so at least following the program
flow is easier.

Read and write do the ref counting differently (but correctly AFAICT) - I want
that changing, but held back from doing it without first checking whether the
later patches (not yet reviewed) provide a reason to prefer one method
over the other.

Alasdair
-- 
agk@redhat.com
