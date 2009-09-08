Return-Path: <linux-kernel-owner+w=401wt.eu-S1752222AbZIHSTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbZIHSTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbZIHSTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:19:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38711 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbZIHSTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:19:39 -0400
Date: Tue, 8 Sep 2009 14:19:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090908181937.GA11545@infradead.org>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <20090908180601.GN22901@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908180601.GN22901@mit.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 02:06:01PM -0400, Theodore Tso wrote:
> Well, we can mostly do this now, using the XFS hack:
> 
>       wbc->nr_to_write *= 4;
> 
> Which is another way of saying, we *know* the page writeback routines
> are on crack, so we'll ignore their suggestion of how many pages to
> write, and we'll try to write more than what they asked us to write.
> 
> (This wasn't a proposed change; it's in Linux 2.6 mainline already;
> see fs/xfs/linux-2.6/xfs_aops.c, in xfs_vm_writepage).  The fact that
> filesystems are playing games like this should be a clear indication
> that things are badly broken above....

Note that we did not put in this hack behind anyones back.  The first
version from Chris was posted on fsdevel, lkml, the ext3 list and so on:

	http://lkml.org/lkml/2008/10/9/237


An when we finally decided that we absolute need it it also made another
roundtrip to linux-mm to hope that we'd get something better from the VM
people:

	http://article.gmane.org/gmane.comp.file-systems.xfs.general/29663

