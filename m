Return-Path: <linux-kernel-owner+w=401wt.eu-S1760153AbXF0GF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760153AbXF0GF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 02:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbXF0GFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 02:05:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49520 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756234AbXF0GFs (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 02:05:48 -0400
Date: Wed, 27 Jun 2007 16:05:31 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Chris Mason <chris.mason@oracle.com>, David Chinner <dgc@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070627060531.GV31489@sgi.com>
References: <20070624014528.GA17609@wotan.suse.de> <20070626030640.GM989688@sgi.com> <46808E1F.1000509@yahoo.com.au> <20070626092309.GF31489@sgi.com> <20070626123449.GM14224@think.oraclecorp.com> <20070627053245.GA6033@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627053245.GA6033@wotan.suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 07:32:45AM +0200, Nick Piggin wrote:
> I think using fsblock to drive the IO and keep the pagecache flags
> uptodate and using a btree in the filesystem to manage extents of block
> allocations wouldn't be a bad idea though. Do any filesystems actually
> do this?

Yes. XFS. But we still need to hold state in buffer heads (BH_delay,
BH_unwritten) that is needed to determine what type of
allocation/extent conversion is necessary during writeback. i.e.
what we originally mapped the page as during the ->prepare_write
call.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
