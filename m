Return-Path: <linux-kernel-owner+w=401wt.eu-S1753154AbZFRIx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbZFRIx4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 04:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbZFRIxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 04:53:48 -0400
Received: from gate.crashing.org ([63.228.1.57]:44847 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbZFRIxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 04:53:47 -0400
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
In-Reply-To: <1245304863.12010.3.camel@penberg-laptop>
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
	 <1245290413.21602.40.camel@pasglop>  <1245295452.21602.42.camel@pasglop>
	 <1245304863.12010.3.camel@penberg-laptop>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 18:52:14 +1000
Message-Id: <1245315134.21602.50.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-18 at 09:01 +0300, Pekka Enberg wrote:
> 
> The only thing I don't like about this patch is that the caller gets
> to decide which bits should be masked. I really think this should be a
> mm_late_init() function that sets the mask _internally_ in the page
> allocator.

Well, the bits are common to slab, slub and page_allocator, so it
doesn't hurt -that- much to have init/main.c use a pre-cooked constant
from gfp.h for that :-)

Also, I still have in mind to use it to clear out some bits during
suspend resume.

But if you really want to be pedantic, we could turn that into inline
functions like gfp_boot_finished() to keep the bits local to gfp.h
completely...

> But anyway, I am about to go completely off-line until Sunday or so
> consider the approach:

Thanks for the ack.

Cheers,
Ben.

