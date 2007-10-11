Return-Path: <linux-kernel-owner+w=401wt.eu-S1757552AbXJKPz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552AbXJKPz0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXJKPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:55:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:6490 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbXJKPzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tVjwWlNjJaPHFb0aGz+n3OGca4ooVanMrWM8r1bLZiCzgguc3Zq15nd/L/Dmd/hhxG2RaWRlVlld0F8E0ivxCOWLqhtM8uq5PZQMgz4Z8SNHBVACGllp8TGu13updVNyAfJbqMs3iSbAtXLl93cRuJjAPuJ8iNvaasplAQnHkiI=
Message-ID: <19f34abd0710110855t58084c62ne3e09227727b7c61@mail.gmail.com>
Date: Thu, 11 Oct 2007 17:55:16 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [PATCH] init: Fix printk format strings
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071011084028.2daf0fd9.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192083422.26648.19.camel@grianne>
	 <20071011084028.2daf0fd9.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 11 Oct 2007 08:17:02 +0200 Vegard Nossum wrote:
>
> > This makes sure printk format strings are string literals containing no
> > more than a single line.
>
> Each patch needs justification (unless it is blatantly obvious).
>
>
> > Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> > ---
> >  init/calibrate.c        |    4 +++-
> >  init/do_mounts_initrd.c |    5 ++++-
> >  init/main.c             |    2 +-
> >  3 files changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
> > index fd4fc12..ad6174c 100644
> > --- a/init/do_mounts_initrd.c
> > +++ b/init/do_mounts_initrd.c
> > @@ -98,7 +98,10 @@ static void __init handle_initrd(void)
> >                       error = sys_ioctl(fd, BLKFLSBUF, 0);
> >                       sys_close(fd);
> >               }
> > -             printk(!error ? "okay\n" : "failed\n");
> > +             if(error)
> > +                     printk("failed\n");
> > +             else
> > +                     printk("okay\n");
> >       }
> >  }
>
> Why this one?
> and if it must change, use:
>                 if (error)
> but I see little need for the change.

Oops about the space. And it's to make the format string a constant
literal. If it isn't, you are going to run into trouble with options
to remove printks at compile-time based on log-level token. I realize
it's not really an issue at this point in time, but I assume that it
will eventually make its way into the kernel in some way or another.

Vegard
