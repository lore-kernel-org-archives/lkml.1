Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZDNSvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZDNSvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 14:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbZDNSvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 14:51:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbZDNSvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 14:51:32 -0400
Date: Tue, 14 Apr 2009 11:46:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Theodore Tso <tytso@mit.edu>
Cc: knikanth@suse.de, jens.axboe@oracle.com, neilb@suse.de,
       linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       shaggy@austin.ibm.com, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Message-Id: <20090414114604.2d552cbb.akpm@linux-foundation.org>
In-Reply-To: <20090414181632.GI955@mit.edu>
References: <200904141636.26557.knikanth@novell.com>
	<20090414111838.GG5178@kernel.dk>
	<200904141711.20378.knikanth@suse.de>
	<20090414181632.GI955@mit.edu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 14:16:32 -0400
Theodore Tso <tytso@mit.edu> wrote:

> In include/linux/page_alloc.h,
> __GFP_NOFAIL is documented as "will never fail", but it says
> absolutely nothing about __GFP_WAIT.

In the present implementation, a __GFP_WAIT allocation for order <=3
will only fail if the caller was oom-killed.

Which raises the question "what happens when a mempool_alloc() caller
gets oom-killed?".

Seems that it will loop around in mempool_alloc() doing weak attempts
to allocate memory, not doing direct reclaim while waiting for someone
else to free something up.  hm.  I guess it'll recover eventually.

