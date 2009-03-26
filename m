Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbZCZMn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbZCZMn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 08:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZCZMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 08:43:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58530 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbZCZMnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 08:43:47 -0400
Date: Thu, 26 Mar 2009 13:43:38 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: serue@us.ibm.com, bfields@fieldses.org, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org
Subject: Re: unprivileged mounts vs. rmdir (was: VFS, NFS security bug? ...)
Message-ID: <20090326124338.GA1466@ucw.cz>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com> <20090311232356.GP13540@fieldses.org> <20090312161047.GA15209@us.ibm.com> <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com> <20090313175848.GB27891@fieldses.org> <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com> <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com> <20090316163611.GB10959@fieldses.org> <20090316170433.GA2996@us.ibm.com> <E1Llk5q-0000kd-IR@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Llk5q-0000kd-IR@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-03-23 14:21:30, Miklos Szeredi wrote:
> [CCs trimmed]
> 
> On Mon, 16 Mar 2009, Serge E. Hallyn wrote:
> > Quoting J. Bruce Fields (bfields@fieldses.org):
> > > special privilege, so don't consult filesystem permissions (do I have
> > > that right?  What happened to the attempt to allow ordinary users to
> > > mount?).
> > 
> > Well, they keep getting stalled because we don't have a good answer for
> > what to do about the fact that an unprivileged user can make trees
> > undeletable by pinning them with mounts.  (Miklos and Eric cc'd in case
> > I didn't explain that well enough).
> 
> That's correct.
> 
> The best answer I can come up with is to allow rmdir/unlink to
> automatically umount trees from their respective dentries.  Obviously
> this can't be done for regular (privileged) mounts, which must keep
> returning EBUSY in such situations.
> 
> But for unprivileged mounts I can't see any fundamental issue with
> such an approach.
> 
> Does anyone see a problem with this?  Is there a better solution?

Well... traditionally if you have an open file or cwd inside mounted
tree... that blocks unmount, right?

What will you do with processes that have open (deleted) files inside
the mount? What about cwd?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
