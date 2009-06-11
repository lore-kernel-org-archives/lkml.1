Return-Path: <linux-kernel-owner+w=401wt.eu-S1760785AbZFKP2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760785AbZFKP2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759687AbZFKP2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:28:06 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41691 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbZFKP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:28:05 -0400
Subject: Re: [PATCH 2/2] SLUB: Disable debugging if it increases the
 minimum page order
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mel@csn.ul.ie, Larry.Finger@lwfinger.net
In-Reply-To: <alpine.DEB.1.10.0906111118350.14020@gentwo.org>
References: <Pine.LNX.4.64.0906111143490.6132@melkki.cs.Helsinki.FI>
	 <alpine.DEB.1.10.0906110941520.29827@gentwo.org>
	 <1244728824.17483.51.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906111021340.29827@gentwo.org>
	 <1244733119.17483.56.camel@penberg-laptop>
	 <alpine.DEB.1.10.0906111118350.14020@gentwo.org>
Date: Thu, 11 Jun 2009 18:28:06 +0300
Message-Id: <1244734086.17483.59.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

On Thu, 11 Jun 2009, Pekka Enberg wrote:
> > I think my patch is the simplest solution here: it turns off debugging
> > for those caches where the metadata bumps up the minimum allocation
> > order and I suspect that we disable cache only for 4096 in practice.

On Thu, 2009-06-11 at 11:20 -0400, Christoph Lameter wrote:
> There could be other slab caches that would randomly be affected by this.
> I ran a couple of times into situations where I had to hack slab to do
> debugging of exempted slabs.

Yes, I do understand that and I have hit that too in the past. But
surely a printk() telling the user we disabled debugging can cure that?

My main point is that a lot of _testers_ will probably enable all SLUB
debugging by default because we encourage them to and it's pretty bad
that we end up causing order 1 allocations and oom conditions.

So I still think we need to fix _at minimum_ the kmalloc-4096 case
(assuming Larry won't hit the same problem still). I see you're not
happy with my patch so any suggestions how to handle that?

			Pekka

