Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbZFRCYk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbZFRCYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:24:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZFRCYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:24:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:44529 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbZFRCYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:24:32 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <alpine.LFD.2.01.0906170941490.16802@localhost.localdomain>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
	 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
	 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
	 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
	 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
	 <20090615101254.GB10294@wotan.suse.de> <1245062388.12400.17.camel@pasglop>
	 <20090615112205.GA6012@wotan.suse.de> <20090615112827.GC6012@wotan.suse.de>
	 <1245101567.12400.38.camel@pasglop>
	 <alpine.DEB.1.10.0906161104480.26093@gentwo.org>
	 <alpine.LFD.2.01.0906161208100.3282@localhost.localdomain>
	 <alpine.DEB.1.10.0906161522370.29941@gentwo.org>
	 <alpine.LFD.2.01.0906161231020.3282@localhost.localdomain>
	 <1245215916.5604.5.camel@penberg-laptop>
	 <alpine.LFD.2.01.0906170941490.16802@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 12:00:12 +1000
Message-Id: <1245290413.21602.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> So I'm very much ok with the whole "use magic gfp_mask to indicate what 
> works at what stage". And yes, I think it makes sense to extend it to the 
> page allocator and might_sleep too, because GFP_KERNEL has all the same 
> issues regardless of whether it's about page allocation or about slab 
> allocators. And any "might_sleep" suppression really does tend to be about 
> the exact same thing.

Argh... still broken.

In fact, my initial patch added it to the page allocator, which worked
for me. Pekka patch removed that and made it slab-only. So I'm blowing
up at boot in lockdep or so because I'm allocating page tables on
ppc32 with __get_free_pages() and GFP_KERNEL.

I'll cook up a patch.

Cheers,
Ben.

