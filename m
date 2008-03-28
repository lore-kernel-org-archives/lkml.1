Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbYC1Azp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbYC1Azp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYC1Az2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:55:28 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:1249 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbYC1Az0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:55:26 -0400
Subject: Re: [PATCH 1/7] [NET]: uninline skb_put, de-bloats a lot
From: Joe Perches <joe@perches.com>
To: Matt Mackall <mpm@selenic.com>
Cc: David Miller <davem@davemloft.net>, ilpo.jarvinen@helsinki.fi,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, acme@redhat.com
In-Reply-To: <1206663095.4122.82.camel@calx>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
	 <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
	 <1206645050.4849.77.camel@localhost>
	 <20080327.150456.39560267.davem@davemloft.net>
	 <1206663095.4122.82.camel@calx>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 17:54:40 -0700
Message-Id: <1206665680.4849.137.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 19:11 -0500, Matt Mackall wrote:
> In the 486 era, when CPU performance was close to 1:1 with memory,
> branches were more expensive than sequential memory fetches, and
> registers were scarce, inlining made a fair amount of sense.
> 
> But now we've moved very far away from that indeed:

Systems have certainly improved but Linux is used in a
wide variety of CPU Hz, memory & register architectures.

Some of those systems haven't changed at all.
Some of those systems have sufficient cache for a
networking stack.

I think this change could negatively impact some of these
different uses and systems.

> In the case of this patch, removing 60-100k from the network stack means
> we're almost certainly avoiding a lot of cache misses in the big picture
> while taking a few cycle hit per packet in the smallest scale.

I think the quantities of big v small are instance dependent
and it might be prudent to have the capability to keep these
functions inline.

