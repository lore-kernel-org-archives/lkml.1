Return-Path: <linux-kernel-owner+w=401wt.eu-S1762442AbYCUV5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762442AbYCUV5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 17:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbYCUV44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 17:56:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51835
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758438AbYCUV44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 17:56:56 -0400
Date: Fri, 21 Mar 2008 14:57:12 -0700 (PDT)
Message-Id: <20080321.145712.198736315.davem@davemloft.net>
To: clameter@sgi.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [11/14] vcompound: Fallbacks for order 1 stack allocations on
 IA64 and x86
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
References: <20080321061726.782068299@sgi.com>
	<20080321.002502.223136918.davem@davemloft.net>
	<Pine.LNX.4.64.0803211037140.18671@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Fri, 21 Mar 2008 10:40:18 -0700 (PDT)

> On Fri, 21 Mar 2008, David Miller wrote:
> 
> > I would be very careful with this especially on IA64.
> > 
> > If the TLB miss or other low-level trap handler depends upon being
> > able to dereference thread info, task struct, or kernel stack stuff
> > without causing a fault outside of the linear PAGE_OFFSET area, this
> > patch will cause problems.
> 
> Hmmm. Does not sound good for arches that cannot handle TLB misses in 
> hardware. I wonder how arch specific this is? Last time around I was told 
> that some arches already virtually map their stacks.

I'm not saying there is a problem, I'm saying "tread lightly"
because there might be one.

The thing to do is to first validate the way that IA64
handles recursive TLB misses occuring during an initial
TLB miss, and if there are any limitations therein.

That's the kind of thing I'm talking about.
