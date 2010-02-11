Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0BKXo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:44:29 -0500
Received: from mail2.shareable.org ([80.68.89.115]:54147 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297Ab0BKXo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:44:28 -0500
Date: Thu, 11 Feb 2010 23:42:49 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Matt Mackall <mpm@selenic.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Clemens Ladisch <clemens@ladisch.de>,
       Olivier Galibert <galibert@pobox.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       David Woodhouse <dwmw2@infradead.org>, linux-embedded@vger.kernel.org
Subject: Re: [PATCH 03/11] readahead: bump up the default readahead size
Message-ID: <20100211234249.GE407@shareable.org>
References: <20100207041013.891441102@intel.com> <20100207041043.147345346@intel.com> <4B6FBB3F.4010701@linux.vnet.ibm.com> <20100208134634.GA3024@localhost> <1265924254.15603.79.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265924254.15603.79.camel@calx>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2010-02-08 at 21:46 +0800, Wu Fengguang wrote:
> > Chris,
> > 
> > Firstly inform the linux-embedded maintainers :)
> > 
> > I think it's a good suggestion to add a config option
> > (CONFIG_READAHEAD_SIZE). Will update the patch..
> 
> I don't have a strong opinion here beyond the nagging feeling that we
> should be using a per-bdev scaling window scheme rather than something
> static.

I agree with both.  100Mb/s isn't typical on little devices, even if a
fast ATA disk is attached.  I've got something here where the ATA
interface itself (on a SoC) gets about 10MB/s max when doing nothing
else, or 4MB/s when talking to the network at the same time.
It's not a modern design, but you know, it's junk we try to use :-)

It sounds like a calculation based on throughput and seek time or IOP
rate, and maybe clamped if memory is small, would be good.

Is the window size something that could be meaningfully adjusted
according to live measurements?

-- Jamie



