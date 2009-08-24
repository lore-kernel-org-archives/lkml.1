Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZHXSst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZHXSst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZHXSss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:48:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51736 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbZHXSss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:48:48 -0400
Date: Mon, 24 Aug 2009 20:48:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Message-ID: <20090824184842.GB29763@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain> <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824135035.GI23677@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824135035.GI23677@mit.edu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > +* don't damage the old data on a failed write (ATOMIC-WRITES)
> > > +
> > > +	(Thrash may get written into sectors during powerfail.  And
> > > +	ext3 handles this surprisingly well at least in the
> > > +	catastrophic case of garbage getting written into the inode
> > > +	table, since the journal replay often will "repair" the
> > > +	garbage that was written into the filesystem metadata blocks.
> > 
> > Isn't this by design?  In other words, if the metadata doesn't survive
> > non-atomic writes, wouldn't it be an ext3 bug?
> 
> So I got confused when I quoted your note, which I had assumed was
> exactly what Pavel had written in his documentation.  In fact, what he
> had written was this:
> 
> +Don't damage the old data on a failed write (ATOMIC-WRITES)
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Either whole sector is correctly written or nothing is written during
> +powerfail.
> +
> +....
> 
> So he had explicitly stated that he only cared about the whole sector
> being written (or not written) in the power fail case, and not any
> other.  I'd suggest changing ATOMIC-WRITES to
> ATOMIC-WRITE-ON-POWERFAIL, since the one-line summary, "Don't damage
> the old data on a failed write", is also singularly misleading.

Ok, something like this?

Don't damage the old data on a powerfail (ATOMIC-WRITES-ON-POWERFAIL)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Either whole sector is correctly written or nothing is written during
powerfail.


									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
