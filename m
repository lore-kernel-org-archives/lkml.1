Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbXBSVxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbXBSVxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 16:53:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932720AbXBSVxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 16:53:10 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26015 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932719AbXBSVxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 16:53:09 -0500
Date: Mon, 19 Feb 2007 16:50:48 -0500
From: Chris Mason <chris.mason@oracle.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
       Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070219215048.GI6133@think.oraclecorp.com>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 11:58:16PM +0300, Ananiev, Leonid I wrote:
> > while triggering EIO in invalidate_inode_pages2_range() 
> ...
> > With this patch aio-stress sees -EIO.
> 
> Actually if invalidate_inode_pages2_range() returns EIO it means
> that internal kernel synchronization conflict was happen.
> It is reported to user as hardware IO error.
> Iteration in synchronization process could be performed instead.
> 

aio is not responsible for this particular synchronization.  Those fixes
(if we make them) should come from other places.  The patch is important
to get aio error handling right.

I would argue that one common cause of the EIO is userland
error (mmap concurrent with O_DIRECT), and EIO is the correct answer.

-chris
