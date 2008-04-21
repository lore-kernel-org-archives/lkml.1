Return-Path: <linux-kernel-owner+w=401wt.eu-S1762110AbYDUNu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110AbYDUNu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 09:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762044AbYDUNtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 09:49:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758563AbYDUNto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 09:49:44 -0400
Date: Mon, 21 Apr 2008 15:49:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [bug] SCSI/SLUB - latest -git: WARNING: at mm/slub.c:2443
	kmem_cache_destroy, scsi_put_host_cmd_pool()
Message-ID: <20080421134925.GK9554@elte.hu>
References: <20080419085758.GA18612@elte.hu> <1208611357.3280.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208611357.3280.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > x86.git allyesconfig bootup test produced the following warning in 
> > slub.c (and a stream of similar warnings later on):
[...]

> > config and bootlog at:
> > 
> >  http://redhat.com/~mingo/misc/config-Sat_Apr_19_10_28_28_CEST_2008.bad
> >  http://redhat.com/~mingo/misc/log-Sat_Apr_19_10_28_28_CEST_2008.bad
> > 
> > [a few .config options were turned off: just accept all the defaults 
> >  after 'make oldconfig']
> 
> The WARN_ON is caused by kmem_cache_destroy() with apparently 
> outstanding objects, isn't it?
> 
> The most significant piece of the log seems to be before with all 
> those isa SCSI drivers ... I assume you don't actually have any of the 
> hardware, you're just randomly inserting the modules?

correct. As i mentioned it in the first sentence this is an allyesconfig 
bzImage bootup. I.e. this is the bootup log of a "make allyesconfig" 
kernel - roughly analogous to (trying to) insert every module in 
existence. In the boot log you'll find 4871 initcalls, done by over 3000 
drivers that each is attempted to be loaded by the kernel (!).

I do those bootups to "run as much as possible" kernel code and to make 
sure that the maximum combination of debug and other features still 
produces a working kernel.

I had to work half a year to gradually get the kernel to that stage 
(started with it more than a year ago, as part of the -rt kernel) but 
these days i'm booting a 32-bit and a 64-bit allyesconfig bzImage kernel 
almost daily :) These bootups already caught a healthy amount of bugs in 
the kernel, both important and unimportant ones. Recently the size of 
the allyesconfig bzImage kernel surpassed 42MB, so it's massive.

Btw., i also boot "allnoconfig" kernels. [with just the minimal set of 
features turned on to make the kernel minimally boot up and report back 
via networking.]

	Ingo
