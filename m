Return-Path: <linux-kernel-owner+w=401wt.eu-S1765590AbXEWRK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765590AbXEWRK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXEWRKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:10:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53272 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755869AbXEWRKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:10:20 -0400
Date: Wed, 23 May 2007 10:10:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <294534.72400.qm@web52611.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705231008250.19822@schroedinger.engr.sgi.com>
References: <294534.72400.qm@web52611.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Srihari Vijayaraghavan wrote:

> > and then try to boot without slub_debug.
> 
> I guess you mean with CONFIG_SLUB_CONFIG=y? If so, I built another kernel with
> CONFIG_SLUB_DEBUG=y (plus all of the above) & tested it. It panics by default,
> but with slub_nomerge it works just fine (tested under moderate load).
> 
> (the panic message produced by CONFIG_SLUB_DEBUG=y was the exact same call
> trace as my very first email in this email thread with slightly different
> address on a couple of functions, but rest remains the same)

Ahh... At least we are getting to the original problem.
 
> I'm personally very happy that slub works stably without slub debug options,
> because that's what I'd run in a production env. Thanks to your patch, slub is
> quite stable without the slub debug for me :-)). But it'd to nice to have a
> working slub debug for test env., as you'd undoubtedly be aware of, of course
> :-). Just my humble opinion.
> 
> > If that fails then boot with slub_nomerge

So lockdep has issues with slab merging? If locks are tracking within 
slabs then I imagine that lockdep gets confused if we put them together.

> Yup, I had to use slub_nomerge; without that CONFIG_SLUB_DEBUG=y kernel
> panics. (I haven't tested the UP case though. I did try nosmp & maxcpus=1, but
> they had no effect on the panic. Do you want me to test UP case for
> CONFIG_SLUB_DEBUG=y without slub_nomerge?)

Yes.

