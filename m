Return-Path: <linux-kernel-owner+w=401wt.eu-S1764409AbXHWROt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764409AbXHWROt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754089AbXHWROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:14:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:59181 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbXHWROl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:14:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DlSrf9ITqYB/OYafKYADjvJR/Sj7SYrtbV57HFDVq/pmbMKoMxHCZk57QPqcGS46goEPt496EvGcH4gPZZi6YomsCcbDWjMrnV8OIbnPYSRek2cPCHaLnPhPe24VNrY9BTPHRv2CKaGFx1Usi8++Gj9McJoxDczJbHdpdt3oD9s=
Message-ID: <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com>
Date: Thu, 23 Aug 2007 10:14:38 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Florin Iucha" <florin@iucha.net>
Subject: Re: NFS woes again Was: [linux-usb-devel] USB-related oops in sysfs with linux v2.6.23-rc3-50-g28e8351
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Jiri Kosina" <jikos@jikos.cz>, linux-usb-devel@lists.sourceforge.net,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <20070823125210.GQ10422@iucha.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz>
	 <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz>
	 <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net>
	 <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz>
	 <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net>
	 <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz>
	 <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/07, Florin Iucha <florin@iucha.net> wrote:
> Trond,
>
> Fess up... I'm closing in:
>
>    http://iucha.net/2.6.23-rc3/2.6.23-rc-bisect.png
>
> [Dropping Jiri and linux-usb-devel from future postings.  You are
> included now just for communicating the conclusion of this thread.]
>
> On Wed, Aug 22, 2007 at 08:22:00AM -0500, Florin Iucha wrote:
> > On Tue, Aug 21, 2007 at 03:42:26PM +0200, Jiri Kosina wrote:
> > > On Tue, 21 Aug 2007, Florin Iucha wrote:
> > >
> > > > There is another interesting angle to this: in the past, every time I
> > > > had keyboard problems, it used to be caused by the VFS and/or NFS...
> > > > after much wrangling, a bunch of bugs were fixed (Hi Trond, Peter,
> > > > Alan!). Now, after the keyboard "locked up", I used the mouse to close
> > > > the gnome session, then I logged-in remotely to reboot.  The reboot
> > > > process locked up and I need to use the reset button!  The second time
> > > > the keyboard "locked up" I listed my processes, and I noticed that I had
> > > > a couple of bash processes and a ssh process in "D" state. Something is
> > > > fishy again in the VFS ;)
> > >
> > > Yes, there were some NFS updates in between -rc2 and
> > > 28e8351ac22de25034e048c680014ad824323c65. I'd be now even more curious
> > > what are you going to find by bisect, please let us know.
> > >
> > > I added Trond to CC, full thread to be found at
> > > http://lkml.org/lkml/2007/8/21/151 for reference.
> > >
> > > Florin, it also might be useful to capture the states of stuck processess
> > > via alt-sysrq-T (or better by echo t > /proc/sysrq-trigger), so that we
> > > know better where are they stuck.
> >
> > This morning it took a bit longer to hang, but it happened.  The
> > backtraces are at http://iucha.net/2.6.23-rc3/backtraces.gz .
> >
> > I'll try a bisect session this weekend.
>
> florin@zeus $ git bisect bad
> Bisecting: 5 revisions left to test after this
> florin@zeus $ git bisect log
> git-bisect start
> # good: [d4ac2477fad0f2680e84ec12e387ce67682c5c13] Linux 2.6.23-rc2
> git-bisect good d4ac2477fad0f2680e84ec12e387ce67682c5c13
> # bad: [28e8351ac22de25034e048c680014ad824323c65] Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes
> git-bisect bad 28e8351ac22de25034e048c680014ad824323c65
> # bad: [8f2ea1fd3f97ab7a809e939b5b9005a16f862439] [POWERPC] Fix initialization and usage of dma_mask
> git-bisect bad 8f2ea1fd3f97ab7a809e939b5b9005a16f862439
> # good: [ff95f3df54609d9d4b9572f8a67d09922a645043] sched: remove the 'u64 now' parameter from pick_next_task()
> git-bisect good ff95f3df54609d9d4b9572f8a67d09922a645043
> # good: [be12014dd7750648fde33e1e45cac24dc9a8be6d] Merge git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched
> git-bisect good be12014dd7750648fde33e1e45cac24dc9a8be6d
> # good: [6a0ed91e361a93ee1efb4c20c4967024ed2a8dd7] hexdump: use const notation
> git-bisect good 6a0ed91e361a93ee1efb4c20c4967024ed2a8dd7
> # bad: [6adb31c90c47262c8a25bf5097de9b3426caf3ae] remove dubious legal statment from uio-howto
> git-bisect bad 6adb31c90c47262c8a25bf5097de9b3426caf3ae
>
> florin
>
> --
> Bruce Schneier expects the Spanish Inquisition.
>       http://geekz.co.uk/schneierfacts/fact/163
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.6 (GNU/Linux)
>
> iD8DBQFGzYL6ND0rFCN2b1sRAqMlAJ9hvBi5oVBeRYZfNwXDG3EmJNgQ4ACbB4V8
> koRJC/8+P1x600SSS51NvZE=
> =+Adv
> -----END PGP SIGNATURE-----

this sounds alot like the post i did yesterday titled 'nfs4 hang regression'
i tracked it down to commit 3d39c691ff486142dd9aaeac12f553f4476b7a6
