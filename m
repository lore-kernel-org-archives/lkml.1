Return-Path: <linux-kernel-owner+w=401wt.eu-S1760071AbYDKKiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760071AbYDKKiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 06:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758450AbYDKKiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 06:38:08 -0400
Received: from lazybastard.de ([212.112.238.170]:57016 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104AbYDKKiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 06:38:07 -0400
Date: Fri, 11 Apr 2008 12:37:57 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [patch 10/15] fs/logfs/memtree.c
Message-ID: <20080411103756.GF25462@logfs.org>
References: <20080401181308.512473173@logfs.org> <20080401181332.853833010@logfs.org> <200804101607.45409.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200804101607.45409.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 April 2008 16:07:44 +0200, Arnd Bergmann wrote:
> On Tuesday 01 April 2008, joern@logfs.org wrote:
> > +#if BITS_PER_LONG == 32
> > +#define BTREE_NODES 20 /* 32bit, 240 byte nodes */
> > +#else
> > +#define BTREE_NODES 16 /* 64bit, 256 byte nodes */
> > +#endif
> > +
> > +struct btree_node {
> > +       u64 key;
> > +       struct btree_node *node;
> > +};
> 
> On 32 bit platforms other than x86, your struct btree_node
> is 16 bytes long because of alignment requirements, rather
> than the 12 bytes you are assuming.

Indeed.  Will change the definition.

Long-term I'd like to generalize the btree a bit and allow three key
variants: long, u64 and u8[].  Some people want to stuff a
(u64, u64, u8) tupel into a btree.  For those it seems ideal to just
treat the key as an array and do memcmp() for comparison.

Jörn

-- 
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike
