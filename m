Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbZLFUZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbZLFUZz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 15:25:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbZLFUZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 15:25:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45533 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZLFUZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 15:25:52 -0500
Date: Sun, 6 Dec 2009 09:46:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091206084633.GA2766@ucw.cz>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-12-02 17:16:57, Miklos Szeredi wrote:
> v2->v3 slightly updated patch description
> 
> Thanks to Alan for the feedback.  The main points raised were I think:
> 
> 1) There's a security hole with dynamicly allocated devices if
> permissions on new device are difference than on old device.
> 
> The issue is valid, but also exists if hard links are created to
> device nodes.  udev already defends against this by setting
> permissions on device to zero before unlinking it.

Perhaps machine has /dev on separate filesystem, not writeable to
users?

Adding new security holes is bad...

> 3) There's an alleged security hole (commonly referred to as "Pavel's
> issue" :) with reopening for write (or truncating) a file desciptor
> through /proc/P/fd for a file descriptor opened for read-only.
> 
> This patch doens't change any of that except the file opened without
> any permission can also be re-opened with increased permissions, as
> long as i_mode allows.  I think this is an othogonal issue and so this
> patch doesn't deal with it.

You just made the hole way more common and easier to exploit.

> Comments?  Any chance of this being accepted into -mm?

With adding 2 new security problems?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
