Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZBVBQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZBVBQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 20:16:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbZBVBQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 20:16:22 -0500
Received: from thunk.org ([69.25.196.29]:40609 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbZBVBQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 20:16:21 -0500
Date: Sat, 21 Feb 2009 20:16:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: Luciano Miguel Ferreira Rocha <luciano@eurotux.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ext4 locks under 2.6.28.3..6
Message-ID: <20090222011617.GD17066@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Luciano Miguel Ferreira Rocha <luciano@eurotux.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <20090220103443.GA3641@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220103443.GA3641@bit.office.eurotux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 10:34:43AM +0000, Luciano Miguel Ferreira Rocha wrote:
> 
> I've experienced intermittent locks on my ext4 filesystems under kernel
> 2.6.28.3 till 2.6.28.6.

Are you still seeing the problem now that you're using 2.6.28.6?  It
looks to me to be another case of bug

http://bugzilla.kernel.org/show_bug.cgi?id=12579
http://bugzilla.kernel.org/show_bug.cgi?id=12610

As I commented in bugid 12610:

>This fix for this has landed in mainline post 2.6.29-rc5, as commit
>2acf2c.  The deadlock is technically not a regression but it was made
>*much* more likely to show up because of commit 31a1266: ("mm:
>write_cache_pages cyclic fix, which show up in 2.6.28.1").
>
>Commit 3a4c68 in mainline backs up the change made in 31a1266, so you
>probably won't see this much after 2.6.28.6 (when 3a4c68 was
>backported to 2.6.28.y), but we should get commit 2acf2c pushed to
>2.6.28.x and 2.6.27.y to completely solve the deadlock problem.

	      	       	  	     	   - Ted
