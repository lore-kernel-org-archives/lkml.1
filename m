Return-Path: <linux-kernel-owner+w=401wt.eu-S1760178AbZFKPtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760178AbZFKPtg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZFKPt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:49:29 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:58736 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751621AbZFKPt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:49:29 -0400
Date: Thu, 11 Jun 2009 11:49:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the minimum
 page order
In-Reply-To: <1244734086.17483.59.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0906111140080.24376@gentwo.org>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>  <alpine.DEB.1.10.0906110941520.29827@gentwo.org>  <1244728824.17483.51.camel@penberg-laptop>  <alpine.DEB.1.10.0906111021340.29827@gentwo.org>  <1244733119.17483.56.camel@penberg-laptop>
  <alpine.DEB.1.10.0906111118350.14020@gentwo.org> <1244734086.17483.59.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Jun 2009, Pekka Enberg wrote:

> My main point is that a lot of _testers_ will probably enable all SLUB
> debugging by default because we encourage them to and it's pretty bad
> that we end up causing order 1 allocations and oom conditions.

Other test methods (like PAGE_ALLOC debugging) also have significant side
effects.

> So I still think we need to fix _at minimum_ the kmalloc-4096 case
> (assuming Larry won't hit the same problem still). I see you're not
> happy with my patch so any suggestions how to handle that?

Add a warning to Kconfig that the higher order page allocations may
increase with debugging on for caches with object sizes near or equal to
PAGE_SIZE?

Its good to run with full debugging on for even the 4k sized caches.
Otherwise we wont be catching overruns there. But the debugging can cause
some side effects.

