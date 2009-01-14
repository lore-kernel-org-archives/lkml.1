Return-Path: <linux-kernel-owner+w=401wt.eu-S1759732AbZANAXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759732AbZANAXP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbZANAWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:22:54 -0500
Received: from intermatrixgroup.ru ([195.178.208.66]:47561 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbZANAWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:22:53 -0500
Date: Wed, 14 Jan 2009 03:22:52 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Miller <davem@davemloft.net>
Cc: dada1@cosmosbay.com, w@1wt.eu, ben@zeus.com, jarkao2@gmail.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090114002252.GE512@ioremap.net>
References: <20090111160548.GA362@ioremap.net> <20090113.160721.68474279.davem@davemloft.net> <20090114001345.GB512@ioremap.net> <20090113.161625.111759506.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113.161625.111759506.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2009 at 04:16:25PM -0800, David Miller (davem@davemloft.net) wrote:
> I wish there were some way we could make this code grab and release a
> reference to the SKB data area (I mean skb_shinfo(skb)->dataref) to
> accomplish it's goals.

Ugh... Clone without cloninig, but by increasing the dataref. Getting
that splice only needs that skb to track the head of the original, this
may really work.

-- 
	Evgeniy Polyakov
