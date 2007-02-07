Return-Path: <linux-kernel-owner+w=401wt.eu-S1161406AbXBGRnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161406AbXBGRnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 12:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161022AbXBGRnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 12:43:53 -0500
Received: from smtp.osdl.org ([65.172.181.24]:57257 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965691AbXBGRnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 12:43:52 -0500
Date: Wed, 7 Feb 2007 09:43:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
Message-Id: <20070207094344.0efdde10.akpm@linux-foundation.org>
In-Reply-To: <200702071750.55283.ak@suse.de>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
	<p73ejp2mfqh.fsf@bingen.suse.de>
	<20070207082330.d07525ec.akpm@linux-foundation.org>
	<200702071750.55283.ak@suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007 17:50:55 +0100 Andi Kleen <ak@suse.de> wrote:

> On Wednesday 07 February 2007 17:23, Andrew Morton wrote:
> > On 07 Feb 2007 11:20:06 +0100 Andi Kleen <ak@suse.de> wrote:
> > 
> > > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> > > 
> > > > current mempolicy just checks whether a node is online or not.
> > > > If there is memory-less-node, mempolicy's target node can be
> > > > invalid.
> > > > This patch adds a check whether a node has memory or not.
> > > 
> > > IMHO there shouldn't be any memory less nodes. The architecture code
> > > should not create them. The CPU should be assigned to a nearby node instead.
> > 
> > umm, why?
> > 
> > A node which has CPUs and no memory is obviously physically possible and
> > isn't a completely insane thing for a user to do.  I'd have thought that
> > the kernel should be able to cleanly and clearly handle it,
> 
> It doesn't.

Fix it?

> > and to 
> > accurately present the machine's topology to the user without us having to
> > go adding falsehoods like this?
> 
> a node is a piece of memory. Without memory it doesn't make sense.

Who said?  I can pick up a piece of circuitry which has four CPUs and no
RAM, wave it about then stick it in a computer.  The kernel is just wrong,
surely?
