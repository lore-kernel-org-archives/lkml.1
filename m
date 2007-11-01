Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbXKAV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbXKAV2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 17:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbXKAV2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 17:28:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41522
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbXKAV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 17:28:10 -0400
Date: Thu, 01 Nov 2007 14:28:09 -0700 (PDT)
Message-Id: <20071101.142809.179954273.davem@davemloft.net>
To: clameter@sgi.com
Cc: dada1@cosmosbay.com, akpm@linux-foundation.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, mathieu.desnoyers@polymtl.ca,
       penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0711010555390.27666@schroedinger.engr.sgi.com>
References: <20071101000211.970501947@sgi.com>
	<47297DA6.5070904@cosmosbay.com>
	<Pine.LNX.4.64.0711010555390.27666@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 1 Nov 2007 05:57:12 -0700 (PDT)

> That is basically what IA64 is doing but it not usable because you would 
> have addresses that mean different things on different cpus. List head
> for example require back pointers. If you put a listhead into such a per 
> cpu area then you may corrupt another cpus per cpu area.

Indeed, but as I pointed out in another mail it actually works if you
set some rules:

1) List insert and delete is only allowed on local CPU lists.

2) List traversal is allowed on remote CPU lists.

I bet we could get all of the per-cpu users to abide by this
rule if we wanted to.

The remaining issue with accessing per-cpu areas at multiple virtual
addresses is D-cache aliasing.
