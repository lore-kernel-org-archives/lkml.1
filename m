Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbZGAPzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbZGAPzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 11:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbZGAPzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 11:55:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60365 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbZGAPzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 11:55:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <ncunningham@crca.org.au>
Subject: Re: [TuxOnIce-devel] RFC: Suspend-to-ram cold boot protection by encrypting page cache
Date: Wed, 1 Jul 2009 17:55:09 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc1-rjw; KDE/4.2.4; x86_64; ; )
Cc: "Jeremy Maitin-Shepard" <jeremy@jeremyms.com>,
       tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
References: <87hbxx0wcp.fsf@jeremyms.com> <87d48k2992.fsf@jeremyms.com> <4A4B27D0.8020906@crca.org.au>
In-Reply-To: <4A4B27D0.8020906@crca.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907011755.10386.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009, Nigel Cunningham wrote:
> Hi again.
> 
> Jeremy Maitin-Shepard wrote:
> > Nigel Cunningham <ncunningham@crca.org.au> writes:
> > 
> >> Hi Jeremy.
> >> I'd suggest emailing the Linux-PM list rather than tuxonice-devel.
> >> TuxOnIce devel focuses on the out-of-vanilla suspend to disk
> >> enhancements rather than on suspend to ram.
> > 
> > The Linux-PM list is a good suggestion, but I specifically included
> > tuxonice because of the note at the bottom --- namely that I believe
> > that tuxonice in particular already includes support for much of what is
> > needed to implement the idea.
> 
> Ah, sorry. I read too quickly.
> 
> > Specifically, suppose right at the stage in tuxonice hibernation when
> > the kernel as about to write the page cache pages to disk, it instead
> > just encrypts in place those pages, clears the encryption key, then
> > waits for the userspace helper to pass it back the key again to use to
> > decrypt the pages.
> > 
> > In fact it would seems that actually entering S3 is mostly irrelevant in
> > terms of the implementation.
> > 
> > Tuoxnice already has code to deal with interfacing with a userspace
> > helper that is kept unfrozen (and its pages handled specially) while
> > everything else is frozen and the page cache is overwritten, which is
> > precisely what is needed for this idea.  In particular, it seems that an
> > implementation of the idea I proposed would look a lot like tuxonice
> > with a powerdown mode of entering S3, just that instead of writing the
> > page cache to disk, it is encrypted in place.  I suppose it could well be that
> > all of the facilities used by tuxonice to do this are actually already
> > in the kernel, in which case it is indeed not relevant to tuxonice, but
> > it is not clear that the uswsusp infrastructure has everything that is
> > needed.
> 
> You're absolutely right - TuxOnIce could be modified to do that, quite
> easily.
> 
> As far as the possibility of using uswsusp goes, I'd like to get
> Rafael's input there - he knows it much better than I do (explicitly
> adding him to the ccs).

No, the current mainline hibernation code can't be modified easily
to encrypt the page cache before suspending.

Also, I don't see much value in doing that before suspend to RAM, because
(1) passwords and encryption keys should be stored in mlocked memory and (2)
the encryption overhead (including measures to protect the encrypted page cache
from being corrupted) would hurt the speed of suspend to RAM and resume, which
is a very important thing.

Moreover, I don't really see how we can feed the decryption key to the
kernel during resume before the page cache can be accessed.

Best,
Rafael
