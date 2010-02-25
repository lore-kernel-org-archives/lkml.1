Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab0BYPBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:01:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab0BYPBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:01:53 -0500
Message-ID: <4B86909E.3080009@redhat.com>
Date: Thu, 25 Feb 2010 10:00:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/15] readahead: limit readahead size for small memory
 systems
References: <20100224031001.026464755@intel.com> <20100224031054.307027163@intel.com>
In-Reply-To: <20100224031054.307027163@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2010 10:10 PM, Wu Fengguang wrote:
> When lifting the default readahead size from 128KB to 512KB,
> make sure it won't add memory pressure to small memory systems.
>
> For read-ahead, the memory pressure is mainly readahead buffers consumed
> by too many concurrent streams. The context readahead can adapt
> readahead size to thrashing threshold well.  So in principle we don't
> need to adapt the default _max_ read-ahead size to memory pressure.
>
> For read-around, the memory pressure is mainly read-around misses on
> executables/libraries. Which could be reduced by scaling down
> read-around size on fast "reclaim passes".
>
> This patch presents a straightforward solution: to limit default
> readahead size proportional to available system memory, ie.
>                  512MB mem =>  512KB readahead size
>                  128MB mem =>  128KB readahead size
>                   32MB mem =>   32KB readahead size (minimal)
>
> Strictly speaking, only read-around size has to be limited.  However we
> don't bother to seperate read-around size from read-ahead size for now.
>
> CC: Matt Mackall<mpm@selenic.com>
> Signed-off-by: Wu Fengguang<fengguang.wu@intel.com>

Acked-by: Rik van Riel <riel@redhat.com>

