Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345Ab0BYWlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 17:41:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934316Ab0BYWlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 17:41:36 -0500
Message-ID: <4B86FC51.80903@redhat.com>
Date: Thu, 25 Feb 2010 17:40:17 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Mason <chris.mason@oracle.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/15] readahead: add /debug/readahead/stats
References: <20100224031001.026464755@intel.com> <20100224031055.024165020@intel.com>
In-Reply-To: <20100224031055.024165020@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> Collect readahead stats when CONFIG_READAHEAD_STATS=y.
>
> This is enabled by default because the added overheads are trivial:
> two readahead_stats() calls per readahead.
>
> Example output:
> (taken from a fresh booted NFS-ROOT box with rsize=16k)
>
> $ cat /debug/readahead/stats
> pattern     readahead    eof_hit  cache_hit         io    sync_io    mmap_io       size async_size    io_size
> initial           524        216         26        498        498         18          7          4          4
> subsequent        181         80          1        130         13         60         25         25         24
> context            94         28          3         85         64          8          7          2          5
> thrash              0          0          0          0          0          0          0          0          0
> around            162        121         33        162        162        162         60          0         21
> fadvise             0          0          0          0          0          0          0          0          0
> random            137          0          0        137        137          0          1          0          1
> all              1098        445         63       1012        874          0         17          6          9
>
> The two most important columns are
> - io		number of readahead IO
> - io_size	average readahead IO size
>
> CC: Ingo Molnar<mingo@elte.hu>
> CC: Jens Axboe<jens.axboe@oracle.com>
> CC: Peter Zijlstra<a.p.zijlstra@chello.nl>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>
