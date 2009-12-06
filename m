Return-Path: <linux-kernel-owner+w=401wt.eu-S934291AbZLFVjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291AbZLFVjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 16:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757683AbZLFVja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 16:39:30 -0500
Received: from thunk.org ([69.25.196.29]:37824 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbZLFVja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 16:39:30 -0500
Date: Sun, 6 Dec 2009 16:39:30 -0500
From: tytso@mit.edu
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>, linux-kernel@vger.kernel.org,
       stewb@linux-foundation.org
Subject: Re: [RFC 0/5] pathconf(3) with _PC_LINK_MAX
Message-ID: <20091206213930.GA10720@thunk.org>
Mail-Followup-To: tytso@mit.edu, Al Viro <viro@ZenIV.linux.org.uk>,
	"J. R. Okajima" <hooanon05@yahoo.co.jp>,
	linux-kernel@vger.kernel.org, stewb@linux-foundation.org
References: <1260086343-8406-1-git-send-email-hooanon05@yahoo.co.jp>
 <20091206083958.GC14381@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091206083958.GC14381@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 08:39:58AM +0000, Al Viro wrote:
> 
> Um...  Why do we need that, again?  Note that there is no way whatsoever
> for predicting whether link(2) will fail due to having too many existing
> links before you attempt the call - links can be created or removed between
> stat(2) and link(2).  So any uses of that value are heuristical.
> 
> Can you actually show any use cases of that thing?  Preferably - in existing
> code, but even a theoretical one would be interesting.

I think it's mainly a "if we're going to implement a POSIX interface,
it would be nice if it returned something based on reality instead of
a wild-assed guess".  :-)

The "real life" use case I could think of is that backup programs that
use hard links everywhere would be able to determine ahead of time in
advance when it might need to create a new file instead of using a
hard link, without needing to do the link and getting the EMLINK
error.  I agree that the only way you can know for sure is by actually
trying the link, so it's a pretty feeble use case.

I will note that without a functional, ext3 and ext4 (or ext3
filesystem with dir_nlink file system feature mounted with ext4) file
systems would be indistinguishable.

						- Ted
