Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbXDDBOQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbXDDBOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:14:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966220AbXDDBOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:14:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:42645 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732AbXDDBOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:14:15 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Miller <davem@davemloft.net>, flar@allandria.com, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1175645568.10567.42.camel@shinybook.infradead.org>
References: <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
	 <1175644642.10567.31.camel@shinybook.infradead.org>
	 <20070403.170212.02298297.davem@davemloft.net>
	 <1175645568.10567.42.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 11:13:12 +1000
Message-Id: <1175649192.30879.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 20:12 -0400, David Woodhouse wrote:
> On Tue, 2007-04-03 at 17:02 -0700, David Miller wrote:
> > Sparc does the same thing, it's a common convention and you really
> > should not break it.
> 
> I thought that argument was lost many years ago. It _used_ to be a
> common convention; we got better.
> 
> > Every powerpc and sparc system out that is using ttyS0 with dynamic
> > minor numbers being allocated.  I really think this should be
> > generalized instead of breaking serial on every powerpc machine out
> > there.
> 
> Nobody's breaking anything. The patch _fixes_ serial, and allows powerpc
> machines to use both z8530 and 8250 ports at the same time; something
> which has been broken for a long time.

It worked before the new serial core, we had a "tweak" in the old 8250
driver to be able to share minors, but that got busted when Russell
rewrote the whole thing. I remember asking him back when he still was
the serial maintainer, and he refused to bring back some sharing of
minors.

Ben.


