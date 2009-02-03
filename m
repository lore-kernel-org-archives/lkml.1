Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZBCOVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZBCOVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZBCOUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:20:54 -0500
Received: from netgear.net.ru ([195.178.208.66]:54528 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbZBCOUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:20:53 -0500
Date: Tue, 3 Feb 2009 17:20:51 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090203142051.GA28744@ioremap.net>
References: <20090202080855.GA4129@ff.dom.local> <20090202.001854.261399333.davem@davemloft.net> <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090203111012.GA16878@ioremap.net> <20090203123628.GB4639@ff.dom.local> <20090203130606.GA25471@ioremap.net> <20090203132537.GC4639@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203132537.GC4639@ff.dom.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 03, 2009 at 01:25:37PM +0000, Jarek Poplawski (jarkao2@gmail.com) wrote:
> Now it's clear. So this looks like one of the options considered by
> David. Then I wonder about details... It seems some kind of scheduled
> browsing for refcounts is needed or is there something better?

It depends on the implementation, for example each kfree() may check the
reference counter and return page to the allocator when it is really
free. Since page may contiain multiple objects its reference counter may
hit zero someday in the future, or never reach it if data was not freed.

-- 
	Evgeniy Polyakov
