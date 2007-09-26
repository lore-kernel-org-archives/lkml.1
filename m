Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbXIZPRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbXIZPRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbXIZPRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:17:32 -0400
Received: from outbound-mail-43.bluehost.com ([69.89.18.12]:36438 "HELO
	outbound-mail-43.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751790AbXIZPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:17:31 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 0/4] allow drivers to flush in-flight DMA
Date: Wed, 26 Sep 2007 08:17:14 -0700
User-Agent: KMail/1.9.7
Cc: akepner@sgi.com, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
References: <20070925235843.GK30013@sgi.com> <20070926064950.GB30430@colo.lackof.org>
In-Reply-To: <20070926064950.GB30430@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709260817.14872.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 12] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 25, 2007 11:49:50 pm Grant Grundler wrote:
> Upon reading the "2) Platforms that permit DMA reordering", I think I
> have been confusing coherency with ordering. I think I have because DMA
> is leaving the "PCI domain", crossing an "unordered domain" (NUMA,
> interconnect), and then finally hitting the cache coherency "domain"
> when it reaches a "far away" memory controller. That's why I've
> been thinking of this as a coherency problem.
>
> The description and API uses the word "flush" (which is ok I guess) instead
> of describing this in terms of enforcing DMA ordering.  Any DMA write to
> the "strongly ordered" region will cause _all_ inflight DMA to be visible
> to cache coherency, thus preserving the illusion of strong DMA ordering.
>
> Does that sound right/better to you too?
> I don't have chipset docs and some of this is just trying to rephrase
> what I've heard before from former SGI employees.

I definitely wouldn't describe this as a coherency issue--the lines involved 
in the DMA writes are fully coherent.  It's really an ordering problem, and 
the new API is setting a "barrier" bit in the DMA address that indicates to 
the bridge that any outstanding DMA should be written before the barriered 
data.  So calling it set_flush or set_barrier is fine with me...

Jesse
