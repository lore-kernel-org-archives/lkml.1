Return-Path: <linux-kernel-owner+w=401wt.eu-S965733AbXBTAbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965733AbXBTAbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965735AbXBTAbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:31:21 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:14799 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965733AbXBTAbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:31:20 -0500
Date: Mon, 19 Feb 2007 19:28:53 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion event
Message-ID: <20070220002853.GL6133@think.oraclecorp.com>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net> <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411> <20070219215048.GI6133@think.oraclecorp.com> <20070220002109.GG31205@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220002109.GG31205@kvack.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 07:21:09PM -0500, Benjamin LaHaise wrote:
> On Mon, Feb 19, 2007 at 04:50:48PM -0500, Chris Mason wrote:
> > aio is not responsible for this particular synchronization.  Those fixes
> > (if we make them) should come from other places.  The patch is important
> > to get aio error handling right.
> > 
> > I would argue that one common cause of the EIO is userland
> > error (mmap concurrent with O_DIRECT), and EIO is the correct answer.
> 
> I disagree.  That means that using the pagecache to synchronize things like 
> the proposed online defragmentation will occasionally make O_DIRECT users 
> fail.  O_DIRECT doesn't prevent the sysadmin from copying files or other 
> page cache uses, which implies that generating an error in these cases is 
> horrifically broken.  If only root could do it, I wouldn't complain, but 
> this would seem to imply that user vs root holes still exist.

I'm working on this part in the placeholder patches.  It's just a separate
problem from the aio code.

-chris

