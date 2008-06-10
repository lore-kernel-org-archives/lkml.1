Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYFJWFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYFJWFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 18:05:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYFJWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 18:05:41 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:55310 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbYFJWFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 18:05:40 -0400
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com,
       Paul Mundt <lethal@linux-sh.org>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20080610143334.c53d7d8a.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	 <20080606202859.291472052@redhat.com>
	 <20080606180506.081f686a.akpm@linux-foundation.org>
	 <20080608163413.08d46427@bree.surriel.com>
	 <20080608135704.a4b0dbe1.akpm@linux-foundation.org>
	 <20080608173244.0ac4ad9b@bree.surriel.com>
	 <20080608162208.a2683a6c.akpm@linux-foundation.org>
	 <20080608193420.2a9cc030@bree.surriel.com>
	 <20080608165434.67c87e5c.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0806101214190.17798@schroedinger.engr.sgi.com>
	 <20080610153702.4019e042@cuia.bos.redhat.com>
	 <20080610143334.c53d7d8a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 15:05:35 -0700
Message-Id: <1213135535.7261.10.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 14:33 -0700, Andrew Morton wrote:
> Maybe it's time to bite the bullet and kill i386 NUMA support.  afaik
> it's just NUMAQ and a 2-node NUMAish machine which IBM made (as400?)

Yeah, IBM sold a couple of these "interesting" 32-bit NUMA machines:

https://www.redbooks.ibm.com/Redbooks.nsf/RedbookAbstracts/tips0267.html?Open

I think those maxed out at 8 nodes, ever.  But, no distro ever turned
NUMA on for i386, so no one actually depends on it working.  We do have
a bunch of systems that we use for testing and so forth.  It'd be a
shame to make these suck *too* much.  The NUMA-Q is probably also so
intertwined with CONFIG_NUMA that we'd likely never get it running
again.

I'd rather just bloat page->flags on these platforms or move the
sparsemem/zone/node bits elsewhere than kill NUMA support.  

-- Dave

