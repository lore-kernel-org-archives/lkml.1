Return-Path: <linux-kernel-owner+w=401wt.eu-S1757252AbXLHCNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252AbXLHCNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 21:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXLHCNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 21:13:10 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:58851 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbXLHCNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 21:13:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FOHWWhUzlbqo9XsR8uySkUA38Xn63aHdPAMR/qIXPlQjKjpziiINWq9JnPLwaHPk9AX0X/hgPbOqUm6XC2Rp7g1yAHze308/1hAOi6UUXpwJ+jCjxDwPQV7J9WQVEa/B1uojDODFUY/J/8Llb87R0ZItYFuUCRwVaObzvqfLnWU=
Message-ID: <fa4052ef0712071813p1edacdfcqe150980e49515f4c@mail.gmail.com>
Date: Fri, 7 Dec 2007 21:13:07 -0500
From: Shane <gnome42@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-git4 NFS crossmnt regression
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, rjw@sisk.pl,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org,
       bfields@fieldses.org, ebiederm@xmission.com, den@openvz.org
In-Reply-To: <20071207161508.afe8fdf1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>
	 <1197067918.10831.13.camel@heimdal.trondhjem.org>
	 <20071207151444.af5d8e11.akpm@linux-foundation.org>
	 <200712080043.29292.rjw@sisk.pl>
	 <20071208000043.GC1951@martell.zuzino.mipt.ru>
	 <20071207161508.afe8fdf1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 7, 2007 7:15 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Sat, 8 Dec 2007 03:00:43 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
>
> > On Sat, Dec 08, 2007 at 12:43:28AM +0100, Rafael J. Wysocki wrote:
> > > On Saturday, 8 of December 2007, Andrew Morton wrote:
> > > > On Fri, 07 Dec 2007 17:51:58 -0500
> > > > Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > >
> > > > >
> > > > > On Fri, 2007-12-07 at 14:39 -0500, Shane wrote:
> > > > > > On Dec 7, 2007 2:16 PM, Shane <gnome42@gmail.com> wrote:
> > > > > > ...
> > > > > > > Confirmed working in rc4-git5.  I'll deploy this kernel in a few more
> > > > > > > spots and check for other regressions.
> > > > > >
> > > > > > Hmm, I installed a new kernel built from the same sources on the NFS
> > > > > > server. And now I don't see anything at all in the crossmnt dirs.
> > > > > >
> > > > > > ls /dirA/dirB/dirC  --> zero output (empty dir)
> > > > > >
> > > > > > Are there any other pending fixes?
> > > > > >
> > > > > > Shane
> > > > >
> > > > > You've probably fallen afoul of
> > > > >
> > > > >    http://bugzilla.kernel.org/show_bug.cgi?id=9504
> > > > >
> > > >
> > > > Yeah.
> > > >
> > > > I have a tentative fix below but I can't seem to get Eric and Denis to get
> > > > a suitable fix nailed down.  It's urgent!
> > >
> > > Well, how about asking Linus to revert commit
> > > 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416 altogether and starting over again?
> > >
> > > It apparently causes more trouble than the issue it was supposed to fix.
> >
> > I very much agree. ->shadow_proc is so ugly, so it's not funny anymore.
> > Adding such hook for proc part of networking _and_ for modules is just asking
> > for trouble as was demonstrated.
>
> OK, perhaps a revert is the best thing to do here.  I don't think anyone
> will be expecting fully finalised and robust netns support in 2.6.24.

I reverted 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416 and it does fix the NFS
server problem with crossmnt's for me.

Shane
