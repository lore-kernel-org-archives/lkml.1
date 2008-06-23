Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYFWD2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYFWD2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 23:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbYFWD2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 23:28:31 -0400
Received: from ozlabs.org ([203.10.76.45]:59974 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752980AbYFWD2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 23:28:30 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc7: BUG: unable to handle kernel NULL pointer dereference
Date: Mon, 23 Jun 2008 13:26:10 +1000
User-Agent: KMail/1.9.9
Cc: "Adrian Bunk" <bunk@kernel.org>, "Srivatsa Vaddagiri" <vatsa@in.ibm.com>,
       "Mike Travis" <travis@sgi.com>, linux-kernel@vger.kernel.org,
       "Gautham R Shenoy" <ego@in.ibm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>
References: <20080622125633.GA8166@damson.getinternet.no> <20080622155627.GA20122@cs181140183.pp.htv.fi> <19f34abd0806220929y1ca9d0c4nbf480473b7ce018a@mail.gmail.com>
In-Reply-To: <19f34abd0806220929y1ca9d0c4nbf480473b7ce018a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806231326.11328.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 June 2008 02:29:07 Vegard Nossum wrote:
> And the (cpu < nr_cpu_ids) fails because the CPU has just been
> offlined (or failed to initialize, but it's the same thing), while
> NR_CPUS is the value that was compiled in as CONFIG_NR_CPUS (so the
> former check will always be true).
>
> I don't think it is valid to ask for a per_cpu() variable on a CPU
> which does not exist, though

Yes it is.  As long as cpu_possible(cpu), per_cpu(cpu) is valid.

The number check should be removed: checking cpu_possible() is sufficient.

Hope that helps,
Rusty.
