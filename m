Return-Path: <linux-kernel-owner+w=401wt.eu-S1759257AbYAXUpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759257AbYAXUpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758696AbYAXUil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:38:41 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:35577 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758697AbYAXUij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:38:39 -0500
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
From: Jon Masters <jonathan@jonmasters.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20080124124703.GB32559@Krystal>
References: <1201029235.18144.62.camel@perihelion>
	 <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal>
	 <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com>
	 <20080123144811.GA12296@Krystal> <27267.1201152358@turing-police.cc.vt.edu>
	 <1201155569.25284.88.camel@perihelion>  <20080124124703.GB32559@Krystal>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Thu, 24 Jan 2008 15:35:31 -0500
Message-Id: <1201206932.25284.143.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 07:47 -0500, Mathieu Desnoyers wrote:
> There seems to be good arguments for markers to support proprierary modules. So
> I am throwing this one-liner in and let's see how people react. It only makes
> sure that a module that has been "forced" to be loaded won't have its markers
> used. It is important to leave this check to make sure the kernel does not crash
> by expecting the markers part of the struct module by mistake in the case there
> is an incorrect checksum.
> 
> It applies fine on 2.6.24-rc8-git3.

I think this should go in.

Signed-off-by: Jon Masters <jcm@jonmasters.org>

Jon.

P.S. wondering out loud to myself, I finally realized the reason we need
a leaf struct_module function in kernel/module.c. We don't necessarily
have anything else checking for changes to struct module on module load
without this, and we have an embedded struct module in each module that
we memory map as we load the module. I did wonder what was protecting us
from that (especially forced loads). But Rusty does think of everything.


