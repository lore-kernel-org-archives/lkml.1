Return-Path: <linux-kernel-owner+w=401wt.eu-S935171AbXHMFjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbXHMFjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 01:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbXHMFjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 01:39:07 -0400
Received: from sccrmhc11.comcast.net ([63.240.77.81]:41263 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbXHMFjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 01:39:06 -0400
Subject: Re: [RFC] FUSE: mnotify (was: [RFC] VFS: mnotify)
From: Nicholas Miell <nmiell@comcast.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0708121322140.28963@fbirervta.pbzchgretzou.qr>
References: <200708120632.20777.a1426z@gawab.com>
	 <Pine.LNX.4.64.0708121322140.28963@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain
Date: Sun, 12 Aug 2007 22:39:01 -0700
Message-Id: <1186983541.2717.6.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-12 at 13:24 +0200, Jan Engelhardt wrote:
> On Aug 12 2007 06:32, Al Boldi wrote:
> >Al Boldi wrote:
> >> Jakob Oestergaard wrote:
> >> > Why on earth would you cripple the kernel defaults for ext3 (which is a
> >> > fine FS for boot/root filesystems), when the *fundamental* problem you
> >> > really want to solve lie much deeper in the implementation of the
> >> > filesystem?  Noatime doesn't solve the problem, it just makes it "less
> >> > horrible".
> >>
> >> inotify could easily solve the atime problem, but it's got the drawback of
> >> forcing the user to register each and every file/dir of interest, which
> >> isn't really reasonable on TB-filesystems.
> 
> What inotify needs is some kind of SUBDIR flag on a watch so that one does not
> run out of fds, then the TB issue becomes a bit lighter I think.
> 

There's no risk of running out of fds; inotify only requires one. You
still have to register every directory you're interested in, though, but
that's a limitation caused by the Unix VFS philosophy and the resulting
filesystem design it inspired rather than of inotify itself.

Come up with a filesystem where given an inode you can find every
directory that has links to that inode with very little effort, convince
everybody to switch from ext3 to this new filesystem, and then maybe
inotify could start doing recursive subtree watches. Otherwise, it's
just not feasible.

-- 
Nicholas Miell <nmiell@comcast.net>

