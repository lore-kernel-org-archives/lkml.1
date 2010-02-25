Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0BYQFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:05:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759413Ab0BYQFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:05:00 -0500
Message-ID: <4B869CBC.5070501@redhat.com>
Date: Thu, 25 Feb 2010 10:52:28 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Andi Kleen <andi@firstfloor.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/15] readahead: replace ra->mmap_miss with ra->ra_flags
References: <20100224031001.026464755@intel.com> <20100224031054.449606633@intel.com>
In-Reply-To: <20100224031054.449606633@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Introduce a readahead flags field and embed the existing mmap_miss in it
> (mainly to save space).
>
> It also changes the mmap_miss upper bound from LONG_MAX to 4096.
> This is to help adapt properly for changing mmap access patterns.
>
> It will be possible to lose the flags in race conditions, however the
> impact should be limited.  For the race to happen, there must be two
> threads sharing the same file descriptor to be in page fault or
> readahead at the same time.
>
> Note that it has always been racy for "page faults" at the same time.
>
> And if ever the race happen, we'll lose one mmap_miss++ or mmap_miss--.
> Which may change some concrete readahead behavior, but won't really
> impact overall I/O performance.
>
> CC: Nick Piggin<npiggin@suse.de>
> CC: Andi Kleen<andi@firstfloor.org>
> CC: Steven Whitehouse<swhiteho@redhat.com>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
