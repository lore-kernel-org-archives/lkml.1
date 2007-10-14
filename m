Return-Path: <linux-kernel-owner+w=401wt.eu-S1763569AbXJNUpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763569AbXJNUpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 16:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbXJNUpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 16:45:38 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:63429 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbXJNUph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 16:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sjsl4CrEYBQRtHCq8ST/EsgwBBJX8qcfl5hGncYreq7HoY/UprGqRX6UepXpgEmCrDzoRuHbvg3t356QOQJsxGZi+oerHpa7UEze6r5A485AAKI4VwFhal8ZV0AOGiJXr1MYamD70eWg9zm76huTvL8Q1RWrO5vbC1JE2fNzsls=
Message-ID: <35fbaa3e0710141345w484b941em831282cf0d49b5c@mail.gmail.com>
Date: Sun, 14 Oct 2007 23:45:36 +0300
From: "Vitaliy Ivanov" <vitalivanov@gmail.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: [2.4 patch] Port of adutux driver from 2.6 kernel to 2.4.
Cc: gregkh@suse.de, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071014182542.GA2832@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192383445.8372.18.camel@dell1.softservecom.com>
	 <20071014182542.GA2832@1wt.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Willy,

On 10/14/07, Willy Tarreau <w@1wt.eu> wrote:
> Hello Vitaliy,
>
> On Sun, Oct 14, 2007 at 08:37:25PM +0300, Vitaliy Ivanov wrote:
> > Hello Willy, Greg and list,
> >
> > I have ported adutux driver for ADU series device list from 2.6 to 2.4.
> > More on devices:
> > http://www.ontrak.net/products.htm#Table%205
> >
> > Once I needed to make ADU200 work under 2.4 enterprise kernel and wasn't able to do this.
> > My organization decided to use another device for our private purposes.
> >
> > I was always interested in kernel hacking and thought it's a good point to start it from.
> > Just to add I'm not related to Ontrak in anyway. Also I'm not a Google person.
> > Did it just for fun.
> >
> > A few technical notes:
> > - I was trying to leave as much as possible adutux driver code from 2.6 as it's in the 2.6 mainline for a long time and seems like it works OK there.
> > - Used one shot interrupt urbs that's why all intervals are 0.
> > - Reused 67 minor number from 2.6 kernel for this device.
> > - All 2.4 related changes are taken/reused from usb-skeleton.
> >
> > Patch is based on the latest 2.4.35.3.
> >
> > Performed a lot of tests but only under UHCI controller and ADU200 and all seems to be OK.
> >
> > I would like someone to perform code review as it's my first attempt to the kernel programming.
> > Any comments, propositions are welcome.
>
> At first glance, your backport looks clean. I have one comment however,
> about the author and version. Since it's a backport from an existing
> driver and not one you wrote yourself (eventhough you did the backporting
> work), the MODULE_AUTHOR should not be changed (but I think you can add
> yourself to it after a comma). The version should reflect the version you
> derived it from, at least for bug tracking purposes.

Sounds good for me. Will correct it.

>
> Also, while I understand you would be very glad to get your work merged
> (we all once had our first piece of code), I'd like to mention that you
> seem to be the only user of this hardware under 2.4 (since it is currently
> not supported). I'm not sure it's very reasonable to merge a driver in 2.4
> right now for just one user. Even more, I understand that you finally moved
> to other hardware, so my feeling is that you did this work as an exercice
> (which was cleanly performed, BTW), but that it will not get any real use
> in 2.4.

Yes, I would like it to be merged... But not just to see my name in
the kernel sources.
I'm the only one user of this hardware under 2.4 because it's some
kind of trick to make it work under 2.4 w/o its support in the kernel.
We moved to the other hardware because of our reasons and some
customers can move to the other OS where this hardware will be
supported.
I'm sure that we're not the first who tried to make it work in 2.4.
Original driver was created for 2.5 and > because interrupt out urbs
were not supported in 2.4. Now it's not an issue.

>
> Since 2.4 is moving very slowly, there should be no problem applying
> this patch to any version if you really need to use it. Maybe it would
> even work with your 2.4 enterprise kernel.
>
> Note that I'm not radically opposed to merge support for new drivers.
> If you provide us with really good arguments for a merge, maybe I'll
> change my opinion, but I doubt about it, since the only users of this
> device must currently be running 2.6.

I'm not going to force you to do this, also I can't do this:). But
after going through the recent news where Greg proposed to create
drivers for companies for free it looks really reasonable. I
understand that we are talking about 2.4 but if you will simply run
diff for adutux of 2.4 and 2.6 you will see that changes are really
trivial.
Also IMHO the more drivers are in the tree the more users will use it.
Once it will be merged in the mainline then it will be backported to
enterprise kernels and would gain wide usage.

Best,
Vitaliy
