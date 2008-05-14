Return-Path: <linux-kernel-owner+w=401wt.eu-S1763273AbYENSax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763273AbYENSax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 14:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbYENSak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 14:30:40 -0400
Received: from waste.org ([66.93.16.53]:55201 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758395AbYENSaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 14:30:39 -0400
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
In-Reply-To: <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
References: <20080510030831.796641881@sgi.com>
	 <20080510030919.604216074@sgi.com> <4825709A.2020407@firstfloor.org>
	 <20080510221515.3540a6cc@bree.surriel.com>
	 <2f11576a0805120038s334dc56cuaf16b8b7c6f87098@mail.gmail.com>
	 <84144f020805120054t1370236ei5ff52279457e026e@mail.gmail.com>
	 <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com>
	 <482B2617.5010605@firstfloor.org>
	 <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Wed, 14 May 2008 13:18:32 -0500
Message-Id: <1210789112.4093.14.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 11:03 -0700, Christoph Lameter wrote:
> > What is the big problem of having a batched free queue? If the expiry
> > is done at a good bounded time (e.g. on interrupt exit or similar)
> > locally on the CPU it shouldn't be a big issue, should it?
> 
> Interrupt exit in general would have to inspect the per cpu structures of 
> all slab caches on the system?

Why's that? When we're not under pressure (fast path), we can delay (and
batch) remote frees. When we are under pressure (slow path), we can do
everything immediately.

-- 
Mathematics is the supreme nostalgia of our time.

