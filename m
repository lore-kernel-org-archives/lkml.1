Return-Path: <linux-kernel-owner+w=401wt.eu-S1759349AbZFPPJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759349AbZFPPJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 11:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753773AbZFPPJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 11:09:33 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34644 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754245AbZFPPJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 11:09:32 -0400
Date: Tue, 16 Jun 2009 11:08:59 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <1245101567.12400.38.camel@pasglop>
Message-ID: <alpine.DEB.1.10.0906161104480.26093@gentwo.org>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>  <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>  <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>  <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> 
 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>  <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>  <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
 <1245101567.12400.38.camel@pasglop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jun 2009, Benjamin Herrenschmidt wrote:

> On Mon, 2009-06-15 at 13:28 +0200, Nick Piggin wrote:
> > If a couple of specialised early boot code places have
> > to test slab_is_available() to prevent crap leaking into
> > our main allocators, then that's quite fine by me.
>
> slab_is_available() will not fix the problem in that case. In fact,
>  existing tests of slab_is_available() have been broken because they
> assumed that when it was true, then GFP_KERNEL would work.

Can we get rid of slab_is_available for that purpose? AFAICT: There needs
to be something that tells us that the page allocator is available or that
the mm subsystem is fully operational.

Could we add more bootup states to enum system_states?

Something like

SYSTEM_BOOTMEM	for the period where only boot memory allocations are possible
SYSTEM_ALLOC_AVAIL	Page / slab allocators available
SYSTEM_PERCPU_AVAIL	Percpu allocator functional
SYSTEM_MEM		Memory subsystem operational.

?


