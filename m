Return-Path: <linux-kernel-owner+w=401wt.eu-S965199AbXBTQCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965199AbXBTQCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:02:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965151AbXBTQCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:02:11 -0500
Received: from pat.uio.no ([129.240.10.15]:46660 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965199AbXBTQCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:02:10 -0500
Subject: Re: [PATCH] aio: propogate post-EIOCBQUEUED errors to completion
	event
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Chris Mason <chris.mason@oracle.com>,
       "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>,
       Zach Brown <zach.brown@oracle.com>, linux-aio@kvack.org,
       linux-kernel@vger.kernel.org, Suparna bhattacharya <suparna@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070220002109.GG31205@kvack.org>
References: <20070219203527.20419.68418.sendpatchset@tetsuo.zabbo.net>
	 <B41635854730A14CA71C92B36EC22AAC83B044@mssmsx411>
	 <20070219215048.GI6133@think.oraclecorp.com>
	 <20070220002109.GG31205@kvack.org>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 11:01:50 -0500
Message-Id: <1171987310.6271.23.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.91 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=12.0, autolearn=disabled, none)
X-UiO-Scanned: 759B7F8C906DC1CA759CCCE525929F3A2AF66F1A
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 57 total 583139 max/h 2803 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-19 at 19:21 -0500, Benjamin LaHaise wrote:
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

We don't try to resolve "conflicting" writes between ordinary mmap() and
write(), so why should we be doing it for mmap and O_DIRECT?

mmap() is designed to violate the ordinary mutex locks for write(), so
if a conflict arises, whether it be with O_DIRECT or ordinary writes
then it is a case of "last writer wins".

Trond

