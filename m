Return-Path: <linux-kernel-owner+w=401wt.eu-S1751971AbZIHTep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbZIHTep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 15:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZIHTeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 15:34:44 -0400
Received: from THUNK.ORG ([69.25.196.29]:52340 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbZIHTeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 15:34:44 -0400
Date: Tue, 8 Sep 2009 15:34:27 -0400
From: Theodore Tso <tytso@mit.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, david@fromorbit.com,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
Message-ID: <20090908193427.GP22901@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, david@fromorbit.com,
	akpm@linux-foundation.org, jack@suse.cz
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com> <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins> <20090908162936.GA2975@think> <20090908180601.GN22901@mit.edu> <20090908181937.GA11545@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090908181937.GA11545@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 08, 2009 at 02:19:37PM -0400, Christoph Hellwig wrote:
> > (This wasn't a proposed change; it's in Linux 2.6 mainline already;
> > see fs/xfs/linux-2.6/xfs_aops.c, in xfs_vm_writepage).  The fact that
> > filesystems are playing games like this should be a clear indication
> > that things are badly broken above....
> 
> Note that we did not put in this hack behind anyones back.  The first
> version from Chris was posted on fsdevel, lkml, the ext3 list and so on:
> 
> An when we finally decided that we absolute need it it also made another
> roundtrip to linux-mm to hope that we'd get something better from the VM
> people:

Sorry, I didn't want to imply that this was done behind anyone's back
--- rather that the fact that we need to do this sort of thing is an
indication that something is badly broken in the page writeback
functions.

I was reacting to Peter's argument that we shouldn't have a
knob/tunable to adjust this limit.  If we can figure out something
which is auto-tuning, that's all very well and good, but the fact that
people have been pointing a problem here for at least a full year,
maybe we should have the tunable now, and then later on, if the VM
crowd can figure out something more clever, we can retire the tunable
at some point in the future.

	   		     	   	     - Ted
