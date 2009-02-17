Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZBQJEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZBQJEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbZBQJEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:04:01 -0500
Received: from stinky.trash.net ([213.144.137.162]:50263 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZBQJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:03:59 -0500
Message-ID: <499A7D7D.1090607@trash.net>
Date: Tue, 17 Feb 2009 10:03:57 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Karl Hiramoto <karl@hiramoto.org>, netdev@vger.kernel.org,
       netfilter@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: problem with IPoA (CLIP),  NAT, and VLANS
References: <20090216232016.GA4803@ami.dom.local>
In-Reply-To: <20090216232016.GA4803@ami.dom.local>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> Very nice debugging, but I think your patch doesn't look like enough:
> 1) it skips copy for cloned skbs,
> 2) this skb_cow_head() is needed anyway, sometimes.
> So the real bug should be found in skb_cow_head() or elsewhere.
> 
> I attach here 2 patches for testing:
> 1) skb->mac_header update: it looks like needed, but I don't know if
>    it matters here,
> 2) an extention of your patch but with pskb_expand_head() called for
>    one to one copy.
> 
> BTW, if it's not a big problem it would be nice to try this e.g. on
> 2.6.29-rc5.

The first patch looks fine. As for the second one, I would like
to understand why we're seing these packets. The VLAN driver uses
the original headroom plus the space it needs itself, which suggests
that the underlying driver specifies an incorrect headroom.
The driver doesn't appear to be part of the mainline kernel though.

