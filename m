Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZKFORq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZKFORq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 09:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZKFORp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 09:17:45 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35037 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417AbZKFORp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 09:17:45 -0500
Date: Fri, 6 Nov 2009 15:17:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091106141742.GA1428@ucw.cz>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu> <20091105131545.72b4e319@lxorguk.ukuu.org.uk> <E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1N63Io-000353-KX@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-11-05 15:27:06, Miklos Szeredi wrote:
> On Thu, 5 Nov 2009, Alan Cox wrote:
> > >  - re-opening normally after checking file type (there's a debate
> > >    whether this would have security issues, but currently we do allow
> > >    re-opening with increased permissions thorugh /proc/*/fd)
> > 
> > Which has already been demonstrated to be an (unfixed) security hole.
> 
> No it hasn't :)  Jamie theorized that there *might* be a real world
> situation where the application writer didn't anticipate this
> behavior.  But as to actual demonstration, we have not seen one yet, I
> think.

See bugtraq, or lkml thread about symlinks with permissions. There's
demo script there.

> And as for reopening O_NODE files with increased permission: that's
> feature people actually expressed interest in, so it's hardly a
> security hole, is it?

Just because people want it does not mean it is not a security hole.

Consider passing /etc/shadow filedesciptor to (legacy) suid root
program. Maybe it now prints /etc/shadow content, because it assumes
that if you have fd you are allowed to read the file?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
