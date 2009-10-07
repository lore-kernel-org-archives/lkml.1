Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbZJGKTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbZJGKTJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758015AbZJGKTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:19:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981AbZJGKTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:19:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091007074902.913463607@intel.com>
References: <20091007074902.913463607@intel.com> <20091007073818.318088777@intel.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li Shaohua" <shaohua.li@intel.com>,
       "Myklebust Trond" <Trond.Myklebust@netapp.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@suse.de>,
       linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/45] writeback: quit on wrap for .range_cyclic (afs)
Date: Wed, 07 Oct 2009 11:17:06 +0100
Message-ID: <32495.1254910626@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> wrote:

> Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
> of the inode, which instructs writeback_single_inode() to delay it for
> a while if necessary.
> 
> It removes one inefficient .range_cyclic IO pattern when writeback_index
> wraps:
> 	submit [10000-10100], (wrap), submit [0-100]
> In which the submitted pages may be consisted of two distant ranges.
> 
> It also prevents submitting pointless IO for busy overwriters.
> 
> CC: David Howells <dhowells@redhat.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>

Acked-by: David Howells <dhowells@redhat.com>
