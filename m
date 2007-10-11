Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbXJKQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbXJKQCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbXJKQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:02:46 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39100 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684AbXJKQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:02:45 -0400
Date: Thu, 11 Oct 2007 09:01:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] init: Fix printk format strings
Message-Id: <20071011090103.5c4bad43.randy.dunlap@oracle.com>
In-Reply-To: <19f34abd0710110855t58084c62ne3e09227727b7c61@mail.gmail.com>
References: <1192083422.26648.19.camel@grianne>
	<20071011084028.2daf0fd9.randy.dunlap@oracle.com>
	<19f34abd0710110855t58084c62ne3e09227727b7c61@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 17:55:16 +0200 Vegard Nossum wrote:

> On 10/11/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Thu, 11 Oct 2007 08:17:02 +0200 Vegard Nossum wrote:
> >
> > > This makes sure printk format strings are string literals containing no
> > > more than a single line.
> >
> > Each patch needs justification (unless it is blatantly obvious).
> >
> >
> > > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> > > ---
> > >  init/calibrate.c        |    4 +++-
> > >  init/do_mounts_initrd.c |    5 ++++-
> > >  init/main.c             |    2 +-
> > >  3 files changed, 8 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
> > > index fd4fc12..ad6174c 100644
> > > --- a/init/do_mounts_initrd.c
> > > +++ b/init/do_mounts_initrd.c
> > > @@ -98,7 +98,10 @@ static void __init handle_initrd(void)
> > >                       error = sys_ioctl(fd, BLKFLSBUF, 0);
> > >                       sys_close(fd);
> > >               }
> > > -             printk(!error ? "okay\n" : "failed\n");
> > > +             if(error)
> > > +                     printk("failed\n");
> > > +             else
> > > +                     printk("okay\n");
> > >       }
> > >  }
> >
> > Why this one?
> > and if it must change, use:
> >                 if (error)
> > but I see little need for the change.
> 
> Oops about the space. And it's to make the format string a constant
> literal. If it isn't, you are going to run into trouble with options
> to remove printks at compile-time based on log-level token. I realize
> it's not really an issue at this point in time, but I assume that it
> will eventually make its way into the kernel in some way or another.

so would this be OK?

		printk("%s\n", error ? "failed" : "okay");


---
~Randy
