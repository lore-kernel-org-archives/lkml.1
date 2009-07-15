Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZGOOlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZGOOlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZGOOlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:41:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:57567 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754937AbZGOOlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:41:51 -0400
Subject: Re: [RFC][PATCH 0/8] Use EDF to throttle RT task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <20090715120802.GD2659@gandalf.sssup.it>
References: <cover.1245092261.git.fabio@helm.retis>
	 <1247135773.9777.357.camel@twins> <20090709135117.GR14563@gandalf.sssup.it>
	 <1247644212.7500.202.camel@twins>  <20090715120802.GD2659@gandalf.sssup.it>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 16:25:51 +0200
Message-Id: <1247667951.5295.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 14:08 +0200, Fabio Checconi wrote:
> 
> > I might have to re-read that mim-concurrency G-EDF paper again, but I
> > failed to spot the bin-packing issue.
> > 

> In the paper you cited, the Conclusion section lists the support for
> dynamic systems and for joining/leaving of tasks as a future work; I
> think that handling (de-)fragmentation and allocation of cpu bandwidth
> when tasks and groups are created/destroyed might be quite complex from
> within the kernel.

Hmm, right, so I was thinking that we could simply create int(w_i) full
cpu and 1 frac(w_i) server tasks and let the single level G-EDF sort it
out.

It looks to me that by only scheduling the leafs of the hierarchy you
side-step a lot of issues, but then maybe it generates other issues :-)

> I'd prefer to have the mechanims enforcing the bandwidth allocation
> inside the kernel, and, eventually, an interface allowing the userspace
> to specify nontrivial allocation schemes, like the one in the paper.

Right.

