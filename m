Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYAIOBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYAIOBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 09:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbYAIOAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 09:00:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34574 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751091AbYAIOAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 09:00:49 -0500
Date: Wed, 9 Jan 2008 15:00:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com, kzak@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
Subject: Re: [patch 7/9] unprivileged mounts: allow unprivileged fuse mounts
Message-ID: <20080109140051.GB12784@elf.ucw.cz>
References: <20080108113502.184459371@szeredi.hu> <20080108113630.861045063@szeredi.hu> <20080108214625.GE5050@ucw.cz> <E1JCN9I-0004DB-DF@pomaz-ex.szeredi.hu> <20080108225820.GA9735@elf.ucw.cz> <E1JCWxm-0005Fn-36@pomaz-ex.szeredi.hu> <20080109113325.GC9735@elf.ucw.cz> <E1JCan7-0005mP-UE@pomaz-ex.szeredi.hu> <20080109133506.GI9735@elf.ucw.cz> <E1JCbIb-0005rA-5O@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1JCbIb-0005rA-5O@pomaz-ex.szeredi.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-01-09 14:48:53, Miklos Szeredi wrote:
> > I'm not saying fuse is worthless. It is a nice toy for single-user
> > systems. But I do not think we should be merging "allow ordinary users
> > to mount their own fuse's" before issues above are fixed.
> 
> I think multi user systems are not all that interesting.  And I
> suspect very few of them want reliably working suspend/hibernate
> (which they wouldn't get due to other issues anyway), or have weird
> shutdown scripts which stop when they are unable to umount
> filesystems.

Weird shutdown scripts? I believe all shutdown scripts have this issue
-- if you want to [cleanly] unmount your / filesystem, you need all
the opens for write closed, right...? Which self-deadlocked fused
holding files open will prevent.

> For paranoid sysadmins, I suggest not enabling fuse for unprivileged
> users, which is pretty easy to do: just don't set /dev/fuse to be
> world read-writable (which is the default BTW).
> 
> So your reasons just don't warrant a big effort involving VFS hacking,
> etc.  Patches are of course welcome.

Well, I believe code with obscure, but almost impossible to fix
problems should not be merged... because that means it will not be
fixed and we'll just have to live with broken kill -9 forever.

Anyway, I believe it would be fair to mention kill -9 no longer
working and shutdown/hibernation/multiuser problems it implies in the
changelogs and probably sysctl documentation or how is this enabled.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
