Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996AbZLRO7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996AbZLRO7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbZLRO7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:59:22 -0500
Received: from thunk.org ([69.25.196.29]:51950 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZLRO7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:59:21 -0500
Date: Fri, 18 Dec 2009 09:59:16 -0500
From: tytso@mit.edu
To: Daniel Poelzleithner <poelzi@poelzi.org>
Cc: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Suggestion: xtime as new inode attribute
Message-ID: <20091218145916.GI2123@thunk.org>
Mail-Followup-To: tytso@mit.edu, Daniel Poelzleithner <poelzi@poelzi.org>,
	Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4B292D9A.5060501@poelzi.org>
 <4B29C5FA.8090909@mnsu.edu>
 <4B2B4B1D.2000806@poelzi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2B4B1D.2000806@poelzi.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 10:27:57AM +0100, Daniel Poelzleithner wrote:
> I think you missunderstood my intension. I wasn't thinking about a
> distribution but the installation on a system. All my systems grow in
> installed packages over time, i think that is something every hard core
> user experiences.
> You test 4-5 programs for a new task you have to do, but over time you
> only use 1-2 of them and simply forget you installed some more programs
> for this.
> With xtime there is a very clean way to find which packages are
> installed and are never used for a long time and can therefore suggested
> to the user to be uninstalled. The cleanup script of course will highly
> depend on the package system used and how the packages are organized and
> named.

This sounds like something a distro might want to do; and as such,
I'll note that if such a feature is *really* wanted, it's something
that can be done in user space --- for example, by adding a hack to
/lib/ld-linux.so which sends a ping-o-gram to a daemon that then
updates the relevant database.  That way you don't penalize every
single inode for something that is only needed for some inodes
(namely, the executables).

An extended attribute might also do, although in that case I'd
strongly suggest that the timestamp field only be updated if the last
execute time is over 24 hours old.  That way you're not constantly
updating the file system for very frequently updated executables such
as "/bin/ls".  Do we really need to know whether /bin/ls was executed
24 seconds ago as opposed to 30 minutes ago?

						- Ted
