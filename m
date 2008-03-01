Return-Path: <linux-kernel-owner+w=401wt.eu-S1758761AbYCAWn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761AbYCAWn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 17:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbYCAWnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 17:43:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43663 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbYCAWnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 17:43:18 -0500
Subject: Re: [patch 1/2] infrastructure to debug (dynamic) objects
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
In-Reply-To: <alpine.LFD.1.00.0803011215490.11084@apollo.tec.linutronix.de>
References: <20080301100019.640027768@linutronix.de>
	 <20080301100325.593267564@linutronix.de>
	 <20080301025134.d9c74110.akpm@linux-foundation.org>
	 <alpine.LFD.1.00.0803011215490.11084@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 01 Mar 2008 23:42:57 +0100
Message-Id: <1204411377.6240.13.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-03-01 at 12:44 +0100, Thomas Gleixner wrote:
> On Sat, 1 Mar 2008, Andrew Morton wrote:

> > > +
> > > +#define ODEBUG_HASH_SIZE	4096
> > 
> > power-of-2 is said to be a very poor size for a hash table.
> 
> The hash is not a randomized hash as one would expect. It's purely
> generated from the object address to simplify the lookup during the
> free check. So the power of 2 size is a good thing :) /me adds
> comment.

Power of two buckets work when used along with a golden ratio based hash
map - as done by linux/hash.h.

Power of two hash maps otoh suck royally.

