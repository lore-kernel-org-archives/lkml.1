Return-Path: <linux-kernel-owner+w=401wt.eu-S1756329AbYHGUKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329AbYHGUKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYHGUKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:10:15 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4072 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752631AbYHGUKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:10:13 -0400
Date: Tue, 5 Aug 2008 20:26:11 +0200
From: Pavel Machek <pavel@suse.cz>
To: Sage Weil <sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ceph-devel@lists.sourceforge.net
Subject: Re: Recursive directory accounting for size, ctime, etc.
Message-ID: <20080805182610.GD8380@ucw.cz>
References: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-07-15 11:28:22, Sage Weil wrote:
> All-
> 
> Ceph is a new distributed file system for Linux designed for scalability 
> (terabytes to exabytes, tens to thousands of storage nodes), reliability, 
> and performance.  The latest release (v0.3), aside from xattr support and 
> the usual slew of bugfixes, includes a unique (?) recursive accounting 
> infrastructure that allows statistics about all metadata nested beneath a 
> point in the directory hierarchy to be efficiently propagated up the tree.  
> Currently this includes a file and directory count, total bytes (summation 
> over file sizes), and most recent inode ctime.  For example, for a 
> directory like /home, Ceph can efficiently report the total number of 
> files, directories, and bytes contained by that entire subtree of the 
> directory hierarchy.
> 
> The file size summation is the most interesting, as it effectively gives 
> you directory-based quota space accounting with fine granularity.  In many 
> deployments, the quota _accounting_ is more important than actual 
> enforcement.  Anybody who has had to figure out what has filled/is filling 
> up a large volume will appreciate how cumbersome and inefficient 'du' can 
> be for that purpose--especially when you're in a hurry.
> 
> There are currently two ways to access the recursive stats via a standard 
> shell.  The first simply sets the directory st_size value to the 
> _recursive_ bytes ('rbytes') value (when the client is mounted with -o 
> rbytes).  For example (watch the directory sizes),
...

> Naturally, there are a few caveats:
> 
>  - There is some built-in delay before statistics fully propagate up 
> toward the root of the hierarchy.  Changes are propagated 
> opportunistically when lock/lease state allows, with an upper bound of (by 
> default) ~30 seconds for each level of directory nesting.

Having instant rctime would be very nice -- for stuff like locate and
speeding up kde startup.

> I'm extremely interested in what people think of overloading the file 
> system interface in this way.  Handy?  Crufty?  Dangerous?  Does anybody 

Too ugly to live.

What about new rstat() syscall?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
