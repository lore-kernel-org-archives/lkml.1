Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZEJOyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZEJOyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 10:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753659AbZEJOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 10:54:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54312 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZEJOyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 10:54:12 -0400
Message-ID: <4A06EA08.1030102@redhat.com>
Date: Sun, 10 May 2009 10:51:52 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, hannes@cmpxchg.org,
       linux-kernel@vger.kernel.org, tytso@mit.edu, linux-mm@kvack.org,
       elladan@eskimo.com, npiggin@suse.de, cl@linux-foundation.org,
       minchan.kim@gmail.com
Subject: Re: [PATCH -mm] vmscan: make mapped executable pages the first class
  citizen
References: <20090430181340.6f07421d.akpm@linux-foundation.org>	<1241432635.7620.4732.camel@twins>	<20090507121101.GB20934@localhost>	<20090507151039.GA2413@cmpxchg.org>	<20090507134410.0618b308.akpm@linux-foundation.org>	<20090508081608.GA25117@localhost>	<20090508125859.210a2a25.akpm@linux-foundation.org>	<20090508230045.5346bd32@lxorguk.ukuu.org.uk>	<2f11576a0905100159m32c36a9ep9fb7cc5604c60b2@mail.gmail.com>	<1241946446.6317.42.camel@laptop>	<2f11576a0905100236u15d45f7fm32d470776659cfec@mail.gmail.com> <20090510144533.167010a9@lxorguk.ukuu.org.uk>
In-Reply-To: <20090510144533.167010a9@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Sun, 10 May 2009 18:36:19 +0900
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
>> I don't oppose this policy. PROT_EXEC seems good viewpoint.
> 
> I don't think it is that simple
> 
> Not only can it be abused but some systems such as java have large
> PROT_EXEC mapped environments, as do many other JIT based languages.

On the file LRU side, or on the anon LRU side?

> Secondly it moves the pressure from the storage volume holding the system
> binaries and libraries to the swap device which already has to deal with
> a lot of random (and thus expensive) I/O, as well as the users filestore
> for mapped objects there - which may even be on a USB thumbdrive.

Preserving the PROT_EXEC pages over streaming IO should not
move much (if any) pressure from the file LRUs onto the
swap-backed (anon) LRUs.

> I still think the focus is on the wrong thing. We shouldn't be trying to
> micro-optimise page replacement guesswork - we should be macro-optimising
> the resulting I/O performance.

Any ideas on how to achieve that? :)

-- 
All rights reversed.
