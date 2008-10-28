Return-Path: <linux-kernel-owner+w=401wt.eu-S1753011AbYJ1CLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbYJ1CLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 22:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbYJ1CLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 22:11:44 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53668 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113AbYJ1CLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 22:11:43 -0400
X-Sasl-enc: rcjoSy0mkoi5YhTJt6vSAmjfknzrjfJ1q9y1vHCYCHZP 1225159902
Subject: Re: [RESEND PATCH] autofs4 - remove string terminator check
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1225159643.2938.23.camel@zeus.themaw.net>
References: <20081028011430.4976.320.stgit@zeus.themaw.net>
	 <20081027185418.0bfd0fcd.akpm@linux-foundation.org>
	 <1225159643.2938.23.camel@zeus.themaw.net>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 11:11:37 +0900
Message-Id: <1225159897.2938.25.camel@zeus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 11:07 +0900, Ian Kent wrote:
> On Mon, 2008-10-27 at 18:54 -0700, Andrew Morton wrote:
> > On Tue, 28 Oct 2008 10:14:30 +0900 Ian Kent <raven@themaw.net> wrote:
> > 
> > > In a previous patch a comment was made that checking for the existence of
> > > a NULL terminator in strings copied from userspace wasn't needed as this
> > > is done in many places in the kernel without problem. This patch removes
> > > this string terminator check.
> > > 
> > 
> > ah, OK.  Now I'm worried.
> > 
> > > 
> > >  fs/autofs4/dev-ioctl.c |   20 --------------------
> > >  1 files changed, 0 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> > > index 625abf5..304c1ff 100644
> > > --- a/fs/autofs4/dev-ioctl.c
> > > +++ b/fs/autofs4/dev-ioctl.c
> > > @@ -51,18 +51,6 @@ static int check_name(const char *name)
> > >  }
> > >  
> > >  /*
> > > - * Check a string doesn't overrun the chunk of
> > > - * memory we copied from user land.
> > > - */
> > > -static int invalid_str(char *str, void *end)
> > > -{
> > > -	while ((void *) str <= end)
> > > -		if (!*str++)
> > > -			return 0;
> > > -	return -EINVAL;
> > > -}
> > > -
> > > -/*
> > >   * Check that the user compiled against correct version of autofs
> > >   * misc device code.
> > >   *
> > > @@ -143,14 +131,6 @@ static int validate_dev_ioctl(int cmd, struct autofs_dev_ioctl *param)
> > >  				    cmd);
> > >  			goto out;
> > >  		}
> > > -
> > > -		err = invalid_str(param->path,
> > > -				 (void *) ((size_t) param + param->size));
> > > -		if (err) {
> > > -			AUTOFS_WARN("invalid path supplied for cmd(0x%08x)",
> > > -				    cmd);
> > > -			goto out;
> > > -		}
> > >  	}
> > >  
> > >  	err = 0;
> > 
> > What will now happen if userspace passes in a non-null-terminated
> > string (if that's possible)?
> > 
> > Presumably that isn't possible, or it's never been tested, because
> > before we check for null-termination we run check_name(), which
> > _assumes_ null-termination!

Oh .. hang on, point taken.

> > 
> > The comment over validate_dev_ioctl() will need the "and is terminated"
> > removed after this change, yes?
> 
> Yes, but now I think I shouldn't have removed it.
> For my part I would have been happy to keep this and now I think I
> should so let's drop this patch.
> 
> Ian
> 

