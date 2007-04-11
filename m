Return-Path: <linux-kernel-owner+w=401wt.eu-S1161318AbXDKWlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161318AbXDKWlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161323AbXDKWll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:41:41 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:38989 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161318AbXDKWlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:41:40 -0400
Message-ID: <461D6413.6050605@cosmosbay.com>
Date: Thu, 12 Apr 2007 00:41:23 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] make MADV_FREE lazily free memory
References: <461C6452.1000706@redhat.com>
In-Reply-To: <461C6452.1000706@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 12 Apr 2007 00:41:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel a écrit :
> Make it possible for applications to have the kernel free memory
> lazily.  This reduces a repeated free/malloc cycle from freeing
> pages and allocating them, to just marking them freeable.  If the
> application wants to reuse them before the kernel needs the memory,
> not even a page fault will happen.
> 

Hi Rik

I dont understand this last sentence. If not even a page fault happens, how 
the kernel knows that the page was eventually reused by the application, and 
should not be freed in case of memory pressure ?

ptr = mmap(some space);
madvise(ptr, length, MADV_FREE);
/* kernel may free the pages */
sleep(10);

/* what the application must do know before reusing space ? */
memset(ptr, data, 10000);
/* kernel should not free ptr[0..10000] now */

Thank you
