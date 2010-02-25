Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab0BYP01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:26:27 -0500
Received: from mtagate2.de.ibm.com ([195.212.17.162]:58929 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab0BYP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:26:25 -0500
Message-ID: <4B869682.9010709@linux.vnet.ibm.com>
Date: Thu, 25 Feb 2010 16:25:54 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>, Vivek Goyal <vgoyal@redhat.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/15] readahead: limit readahead size for small memory
 systems
References: <20100224031001.026464755@intel.com> <20100224031054.307027163@intel.com>
In-Reply-To: <20100224031054.307027163@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Wu Fengguang wrote:
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
 >                 512MB mem => 512KB readahead size
 >                 128MB mem => 128KB readahead size
 >                  32MB mem =>  32KB readahead size (minimal)
 >
 > Strictly speaking, only read-around size has to be limited.  However we
 > don't bother to seperate read-around size from read-ahead size for now.
 >
 > CC: Matt Mackall <mpm@selenic.com>
 > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

What I state here is for read ahead in a "multi iozone sequential" 
setup, I can't speak for real "read around" workloads.
So probably your table is fine to cover read-around+read-ahead in one 
number.

I have tested 256MB mem systems with 512kb readahead quite a lot.
On those 512kb is still by far superior to smaller readaheads and I 
didn't see major trashing or memory pressure impact.

Therefore I would recommend a table like:
                >=256MB mem => 512KB readahead size
                  128MB mem => 128KB readahead size
                   32MB mem =>  32KB readahead size (minimal)

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
