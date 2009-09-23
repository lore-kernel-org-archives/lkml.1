Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbZIWC4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbZIWC4h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753819AbZIWC4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:56:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785AbZIWC4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:56:36 -0400
Date: Tue, 22 Sep 2009 19:56:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-Id: <20090922195605.a9a7aca8.akpm@linux-foundation.org>
In-Reply-To: <20090923024958.GA13205@localhost>
References: <1253608335.8439.283.camel@twins>
	<20090922155259.GL10825@think>
	<20090923002220.GA6382@localhost>
	<20090922175452.d66400dd.akpm@linux-foundation.org>
	<20090923011758.GC6382@localhost>
	<20090922182832.28e7f73a.akpm@linux-foundation.org>
	<20090923014500.GA11076@localhost>
	<20090922185941.1118e011.akpm@linux-foundation.org>
	<20090923022622.GB11918@localhost>
	<20090922193622.42c00012.akpm@linux-foundation.org>
	<20090923024958.GA13205@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 10:49:58 +0800 Wu Fengguang <fengguang.wu@intel.com> wrote:

> > After the sleep we repoll all queues.
> 
> I mean, it is not always necessary. Only when _all_ superblocks cannot
> writeback their inodes (eg. all in congestion), we should wait.

Well.  The code will still submit MAX_WRITEBACK_PAGES pages to _some_
queue in that situation.

But yup, maybe that's a bug!  Sounds easy to fix.  It doesn't justify
rewriting the whole world and then saying "look, the new code is faster
than the old code which had a bug which I knew about but didn't fix".

