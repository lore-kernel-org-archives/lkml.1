Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0BBSNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 13:13:23 -0500
Received: from alt.dspnet.fr.eu.org ([213.186.44.138]:4473 "EHLO
	dspnet.fr.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756476Ab0BBSNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 13:13:22 -0500
Date: Tue, 2 Feb 2010 19:13:21 +0100
From: Olivier Galibert <galibert@pobox.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/11] readahead: dont do start-of-file readahead after lseek()
Message-ID: <20100202181321.GB75577@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <jens.axboe@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20100202152835.683907822@intel.com> <20100202153317.644170708@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100202153317.644170708@intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 11:28:45PM +0800, Wu Fengguang wrote:
> Some applications (eg. blkid, id3tool etc.) seek around the file
> to get information. For example, blkid does
> 	     seek to	0
> 	     read	1024
> 	     seek to	1536
> 	     read	16384
> 
> The start-of-file readahead heuristic is wrong for them, whose 
> access pattern can be identified by lseek() calls.
> 
> So test-and-set a READAHEAD_LSEEK flag on lseek() and don't
> do start-of-file readahead on seeing it. Proposed by Linus.

Wouldn't that trigger on lseeks to end of file to get the size?

  OG.

