Return-Path: <linux-kernel-owner+w=401wt.eu-S934080AbXCTVgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080AbXCTVgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934081AbXCTVgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:36:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33453 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934080AbXCTVgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:36:47 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: David Woodhouse <dwmw2@infradead.org>
To: dedekind@infradead.org
Cc: David Lang <david.lang@digitalinsight.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, Theodore Tso <tytso@mit.edu>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1174421151.17249.168.camel@sauron>
References: <20070318162720.GI10459@waste.org>
	 <1174236579.17249.6.camel@sauron> <20070318191812.GM4892@waste.org>
	 <20070318203149.GC29295@crusty.rchland.ibm.com>
	 <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
	 <1174406395.30079.139.camel@zod.rchland.ibm.com>
	 <Pine.LNX.4.63.0703201049310.8684@qynat.qvtvafvgr.pbz>
	 <1174421151.17249.168.camel@sauron>
Content-Type: text/plain
Date: Tue, 20 Mar 2007 21:36:31 +0000
Message-Id: <1174426591.20505.20.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 22:05 +0200, Artem Bityutskiy wrote:
> Guess why we still do not have a decent FTL? Because it is
> _difficult_. 

No. We don't have a decent FTL because it's _pointless_. We've got basic
implementations of FTL, NFTL, INFTL etc. for compatibility with PCMCIA
stuff and DiskOnChip, but the fact remains that pretending to be a
normal block device with atomically-overwritten 512-byte sectors is just
_stupid_. You end up implementing a kind of pseudo-filesystem to do
that, and then on top of that you put a 'normal' filesystem with no real
knowledge about what's underneath. It's crap -- and as we currently have
it, the top level file system doesn't even get to tell the underlying
FTL that a given block can be discarded because it's no longer used. So
during garbage collection the FTL even ends up copying crap around the
medium that's no longer relevant.

This isn't DOS. We don't have to make our storage available through the
restricted interface that INT 13h offers us. We can, and do, do better
than that. And that's why we don't have a decent FTL implementation.

-- 
dwmw2

