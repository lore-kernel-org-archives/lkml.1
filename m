Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYD2Br3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYD2Br3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYD2BrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:47:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41780 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYD2BrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:47:20 -0400
Date: Tue, 29 Apr 2008 02:47:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: umount(/proc) after CLONE_NEWNS in 2.6.25?
Message-ID: <20080429014718.GI5882@ZenIV.linux.org.uk>
References: <481609A5.1080905@msgid.tls.msk.ru> <20080428182759.GF5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428182759.GF5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 07:27:59PM +0100, Al Viro wrote:
> > [pid 6308] clone(child_stack=0xbfc9de94, flags=CLONE_NEWNS|SIGCHLD) = 6309
> > [pid  6309] execve("/usr/sbin/umount", ["umount", "-n", "/proc"])
> > ...
> > [pid  6309] oldumount("/proc")          = -1 EBUSY (Device or resource busy)
> > umount: /proc: device is busy
> >
> > Yes, various NAMESPACEs are enabled (i'm trying to experiment with
> > those).
> >
> > Is it intentional?
> 
> It's very odd.  Could you bisect that down to offending changeset or
> at least narrow the things down to -rc<something>?  I'm going down right
> now, so won't be able to look into that until tonight...

Check the version of umount(8) you've got.  And see if that strace happens
to have open of /proc/mounts, without matching close by the time it calls
umount().  util-linux-ng 2.13.1 is _that_ dumb...

Please, make sure that you are using the same userland for testing - with
aforementioned version of umount(8) behaviour is triggered with .24 as well
as with .25 and there's nothing kernel could do about that...
