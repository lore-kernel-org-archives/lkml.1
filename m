Return-Path: <linux-kernel-owner+w=401wt.eu-S1765460AbZEAUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765460AbZEAUK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 16:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762447AbZEAUKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 16:10:10 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34668 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbZEAUKI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 16:10:08 -0400
Message-ID: <49FB56C3.4030407@redhat.com>
Date: Fri, 01 May 2009 16:08:35 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: Andrew Morton <akpm@linux-foundation.org>, elladan@eskimo.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
References: <20090428044426.GA5035@eskimo.com> <20090430072057.GA4663@eskimo.com> 	<20090430174536.d0f438dd.akpm@linux-foundation.org> <20090430205936.0f8b29fc@riellaptop.surriel.com> 	<20090430181340.6f07421d.akpm@linux-foundation.org> <20090430215034.4748e615@riellaptop.surriel.com> 	<20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com> 	<2c0942db0905011104u4e6df9ap9d95fa30b1284294@mail.gmail.com> 	<49FB4EBB.3030404@redhat.com> <2c0942db0905011244v331273dfr2bb34953e42bebdf@mail.gmail.com>
In-Reply-To: <2c0942db0905011244v331273dfr2bb34953e42bebdf@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ray Lee wrote:

> Streaming IO should always be at the bottom of the list as it's nearly
> always use-once. That's not the interesting case.

Unfortunately, on current 2.6.28 through 2.6.30 that is broken.

Streaming IO will eventually eat away all of the pages on the
active file list, causing the binaries and libraries that programs
used to be kicked out of memory.

Not interesting?

> The interesting case is an updatedb running in the background, paging
> out firefox, or worse, parts of X. That sucks.

This is a combination of use-once IO and VFS metadata.

The used-once pages can be reclaimed fairly easily.

The growing metadata needs to be addressed by putting pressure
on it via the slab/slub/slob shrinker functions.

-- 
All rights reversed.
