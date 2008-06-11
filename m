Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYFKMGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYFKMGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 08:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYFKMGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 08:06:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52395 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbYFKMGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 08:06:19 -0400
Message-ID: <484FBFB7.4070506@firstfloor.org>
Date: Wed, 11 Jun 2008 14:06:15 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Mundt <lethal@linux-sh.org>, Rik van Riel <riel@redhat.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org, eric.whitney@hp.com,
       Ingo Molnar <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
References: <20080606180506.081f686a.akpm@linux-foundation.org>	<20080608163413.08d46427@bree.surriel.com>	<20080608135704.a4b0dbe1.akpm@linux-foundation.org>	<20080608173244.0ac4ad9b@bree.surriel.com>	<20080608162208.a2683a6c.akpm@linux-foundation.org>	<20080608193420.2a9cc030@bree.surriel.com>	<20080608165434.67c87e5c.akpm@linux-foundation.org>	<Pine.LNX.4.64.0806101214190.17798@schroedinger.engr.sgi.com>	<20080610153702.4019e042@cuia.bos.redhat.com>	<20080610143334.c53d7d8a.akpm@linux-foundation.org>	<20080611050914.GA27488@linux-sh.org> <20080610231642.6b4b5a53.akpm@linux-foundation.org>
In-Reply-To: <20080610231642.6b4b5a53.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Andi has suggested that we can remove the node-ID encoding from
> page.flags on x86 because that info is available elsewhere, although a
> bit more slowly.
> 
> <looks at page_zone(), wonders whether we care about performance anyway>

It would be just pfn_to_nid(page_pfn(page)) for 32bit && CONFIG_NUMA.
-sh should have that too.

Only trouble is that it needs some reordering because right now page_pfn
is not defined early enough.

> There wouldn't be much point in doing that unless we did it for all
> 32-bit architectures.  How much trouble would it cause sh?

Probably very little from a quick look at the source.

-Andi
