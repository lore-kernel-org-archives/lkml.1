Return-Path: <linux-kernel-owner+w=401wt.eu-S1758029AbXFUSdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbXFUSdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbXFUSd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:33:26 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54048 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753006AbXFUSdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:33:24 -0400
Date: Thu, 21 Jun 2007 20:33:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Crispin Cowan <crispin@novell.com>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070621183311.GC18990@elf.ucw.cz>
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070616000251.GG2616@elf.ucw.cz> <20070621160840.GA20105@marowsky-bree.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621160840.GA20105@marowsky-bree.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've caught up on this thread with growing disbelief while reading the
> mails, so much that I've found it hard to decide where to reply to.
> 
> So people are claiming that AA is ugly, because it introduces pathnames
> and possibly a regex interpreter. Ok, taste differs. We've got many
> different flavours of filesystems in the kernel because of that.
> 
> However, the suggested cure makes me cringe.
> 
> You're saying that relabeling file(s) from user-space after a rename is
> a possible solution.
> 
> This breaks POSIX - renames must be atomic. It is possibly insecure; if
> this is fixed by making a rename automatically default to restrictive
> permissions, it'll be even more inconvenient. It will break
> applications

inconvenient, yes, insecure, no.

I believe AA breaks POSIX, already. rename() is not expected to change
permissions on target, nor is link link. And yes, both of these make
AA insecure.

> You _must_ be kidding. The cure is worse than the problem.

Possibly.

> If that is the only way to implement AA on top of SELinux - and so far,
> noone has made a better suggestion - I'm convinced that AA has technical
> merit: it does something the on-disk label based approach cannot handle,
> and for which there is demand.

What demand? SELinux is superior to AA, and there was very little
demand for AA. Compare demand for reiser4 or suspend2 with demand for
AA.

> The code has improved, and continues to improve, to meet all the coding
> style feedback except the bits which are essential to AA's function

Which are exactly the bits Christoph Hellwig and Al Viro
vetoed. http://www.uwsg.iu.edu/hypermail/linux/kernel/0706.1/2587.html
. I believe it takes more than "2 users want it" to overcome veto of
VFS maintainer.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
