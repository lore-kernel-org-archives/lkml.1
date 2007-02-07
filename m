Return-Path: <linux-kernel-owner+w=401wt.eu-S965676AbXBGQvM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965676AbXBGQvM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:51:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965688AbXBGQvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:51:12 -0500
Received: from ns1.suse.de ([195.135.220.2]:54918 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965676AbXBGQvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:51:11 -0500
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with memory-less-node
Date: Wed, 7 Feb 2007 17:50:55 +0100
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com> <p73ejp2mfqh.fsf@bingen.suse.de> <20070207082330.d07525ec.akpm@linux-foundation.org>
In-Reply-To: <20070207082330.d07525ec.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071750.55283.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 February 2007 17:23, Andrew Morton wrote:
> On 07 Feb 2007 11:20:06 +0100 Andi Kleen <ak@suse.de> wrote:
> 
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> > 
> > > current mempolicy just checks whether a node is online or not.
> > > If there is memory-less-node, mempolicy's target node can be
> > > invalid.
> > > This patch adds a check whether a node has memory or not.
> > 
> > IMHO there shouldn't be any memory less nodes. The architecture code
> > should not create them. The CPU should be assigned to a nearby node instead.
> 
> umm, why?
> 
> A node which has CPUs and no memory is obviously physically possible and
> isn't a completely insane thing for a user to do.  I'd have thought that
> the kernel should be able to cleanly and clearly handle it,

It doesn't.

> and to 
> accurately present the machine's topology to the user without us having to
> go adding falsehoods like this?

a node is a piece of memory. Without memory it doesn't make sense.

-Andi
 
