Return-Path: <linux-kernel-owner+w=401wt.eu-S1760503AbZENRHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760503AbZENRHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbZENRHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:07:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754011AbZENRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:07:31 -0400
Date: Thu, 14 May 2009 10:07:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Micha=5F=5F?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
       m.szyprowski@samsung.com, kyungmin.park@samsung.com, linux-mm@kvack.org
Subject: Re: [PATCH] Physical Memory Management [0/1]
Message-Id: <20090514100718.d8c20b64.akpm@linux-foundation.org>
In-Reply-To: <op.utw7yhv67p4s8u@amdc030>
References: <op.utu26hq77p4s8u@amdc030>
	<20090513151142.5d166b92.akpm@linux-foundation.org>
	<op.utwwmpsf7p4s8u@amdc030>
	<1242300002.6642.1091.camel@laptop>
	<op.utw4fdhz7p4s8u@amdc030>
	<1242302702.6642.1140.camel@laptop>
	<op.utw7yhv67p4s8u@amdc030>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 15:04:55 +0200
Micha__ Nazarewicz <m.nazarewicz@samsung.com> wrote:

> On Thu, 14 May 2009 14:05:02 +0200, Peter Zijlstra wrote:
> > And who says your pre-allocated pool won't fragment with repeated PMM
> > use?
> 
> Yes, this is a good question.  What's more, there's no good answer. ;)
> 

We do have capability in page reclaim to deliberately free up
physically contiguous pages (known as "lumpy reclaim").

It would be interesting were someone to have a go at making that
available to userspace: ask the kernel to give you 1MB of physically
contiguous memory.  There are reasons why this can fail, but migrating
pages can be used to improve the success rate, and userspace can be
careful to not go nuts using mlock(), etc.

The returned memory would of course need to be protected from other
reclaim/migration/etc activity.

