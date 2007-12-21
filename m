Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbXLUVcb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbXLUVcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 16:32:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbXLUVcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 16:32:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:42307 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbXLUVcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 16:32:23 -0500
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: akepner@sgi.com
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071221180022.GW412@sgi.com>
References: <20071218001758.GO21916@sgi.com>
	 <4767FA62.9060002@s5r6.in-berlin.de> <20071218200759.GE412@sgi.com>
	 <1198184185.6779.16.camel@pasglop>  <20071221180022.GW412@sgi.com>
Content-Type: text/plain
Date: Sat, 22 Dec 2007 08:31:30 +1100
Message-Id: <1198272690.6737.21.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-21 at 10:00 -0800, akepner@sgi.com wrote:
> On Fri, Dec 21, 2007 at 07:56:25AM +1100, Benjamin Herrenschmidt wrote:
> > ...
> > Can't you just have a primitive to sync things up that you call
> > explicitely from your driver after fetching a new status entry ?
> > 
> 
> Well, the only mechanisms I know to get things synced are the ones 
> I mentioned before: 1) generate an interrupt, 2) write to memory 
> which has the "barrier" attribute. Obviously 1 is out - giving  
> the memory used for status indications the barrier attribute is 
> the most primitive means I'm aware of.

Well, I'm not totally against turning "direction" into a flag mask, as I
do have requests to do something similar on some PowerPC's in fact in
order to control the ordering guarantees of a given DMA mapping (ie.
relaxed vs. fully ordered).

I'm just worried that we'll end up with as many semantics for those
flags as we have host bridges & archs around, which would be bad.

Ben.


