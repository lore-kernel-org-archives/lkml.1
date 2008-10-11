Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYJKPlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYJKPlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 11:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYJKPlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 11:41:23 -0400
Received: from kroah.org ([198.145.64.141]:55975 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753519AbYJKPlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 11:41:23 -0400
Date: Sat, 11 Oct 2008 08:39:18 -0700
From: Greg KH <greg@kroah.com>
To: Tzafrir Cohen <tzafrir.cohen@xorcom.com>
Cc: linux-kernel@vger.kernel.org, David Rowe <david@rowetel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 16/23] Staging: add echo cancelation module
Message-ID: <20081011153918.GA31405@kroah.com>
References: <20081010224130.GA30117@kroah.com> <1223678567-30143-16-git-send-email-greg@kroah.com> <20081011063310.GW31838@xorcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081011063310.GW31838@xorcom.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2008 at 08:33:10AM +0200, Tzafrir Cohen wrote:
> While there are a number of small issues in this code, I personally
> would like to first and foremost get a usable interface so I could get a
> working echo canceller module into dahdi:
> http://svn.digium.com/svn/dahdi/linux/trunk/
> http://svn.digium.com/svn/dahdi/linux/trunk/drivers/dahdi/

Ok, that's great.  I'm not saying that the current interface for this
driver is correct, that is why it is in the staging tree :)

It will change, don't worry.

But, what should it change into?

> 1. echo.h (The interface) needlessly includes the definition of 
> definition of echo_can_state_t. Anywhere in the interface it is used as
> a pointer, including a _create and _destory function.

Simple to fix up.

> 2. Furthermore, anybody that includes fir.h must also define malloc 
>    first. See echo.c . fir.h is included for the definition of
>    echo_can_state_t .

That will be resolved as well.

> 3. In that specific environment (dahdi/zaptel) echo_can is not a very
> unique prefix. Thus in my provisional change I added oslec_ as a prefix.

Ok, that seems very reasonable.  The whole module should probably have
that added as a prefix as well.

> I'm not sure how much (3) counts here.

Lots :)

> My current working tree is in not in the best place: the debian
> (non-existing) package dahdi-linux . See 
> 
>   http://svn.debian.org/viewsvn/pkg-voip?rev=6284&view=rev
> 
> I hope that once I get a clear enough interface I can kick out the oslec
> subdirectory and move the EC module upstream.

Care to send me patches to help resolve these issues to make it easier
for you?

> On Fri, Oct 10, 2008 at 03:42:40PM -0700, Greg KH wrote:
> 
> > diff --git a/drivers/staging/echo/TODO b/drivers/staging/echo/TODO
> > new file mode 100644
> > index 0000000..1ca09af
> > --- /dev/null
> > +++ b/drivers/staging/echo/TODO
> > @@ -0,0 +1,10 @@
> > +TODO:
> 
> > +	- remove proc interface, only use echo.h interface (proc interface is
> > +	  racy and not correct.)
> 
> Already done, right? I don't see any _wrapper.c around.

Ah, good point, forgot that was already removed.

thanks,

greg k-h
