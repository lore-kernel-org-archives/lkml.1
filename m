Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbXIZPCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbXIZPCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbXIZPCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:02:43 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1249 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234AbXIZPCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:02:43 -0400
Date: Wed, 26 Sep 2007 17:02:38 +0200
From: Olivier Galibert <galibert@pobox.com>
To: David Newall <david@davidnewall.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Adrian Bunk <bunk@kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Subject: Re: Chroot bug
Message-ID: <20070926150238.GA43852@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	David Newall <david@davidnewall.com>,
	Kyle Moffett <mrmacman_g4@mac.com>, Adrian Bunk <bunk@kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
	majkls <majkls@prepere.com>, bunk@fs.tum.de,
	linux-kernel@vger.kernel.org
References: <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de> <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com> <46FA341A.80706@davidnewall.com> <20070926104500.GA4354@dspnet.fr.eu.org> <46FA3EE8.4080707@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46FA3EE8.4080707@davidnewall.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 08:43:44PM +0930, David Newall wrote:
> Olivier Galibert wrote:
> >chroot does not allow you to walk out if you're in.
> 
> You're mistaken.  Or more properly, further use of chroot lets you walk 
> out.  This really has been said before, and before, and before.
> 
>    chroot("subtree");   // enter chroot
>    chdir("/");    // now at subtree
>    chroot("/tmp");   // now outside of chroot

Of course.  chroots are not a stack, they're just a point in the
namespace.  You change it, the conditions apply to the new one.


> BSD redefined chroot so that the working directory is set to the new 
> root on subsequent uses of chroot; that's how they solved the bug.

They didn't solve a thing.  fchdir baby.  Unless you want to remove
fchdir.  And mknod.  And mount.  And so many other different syscalls
that I don't even know the list.

  OG.
