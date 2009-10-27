Return-Path: <linux-kernel-owner+w=401wt.eu-S932342AbZJ0Ux1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342AbZJ0Ux1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbZJ0Ux0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:53:26 -0400
Received: from kroah.org ([198.145.64.141]:51353 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbZJ0Ux0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:53:26 -0400
Date: Tue, 27 Oct 2009 13:44:45 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: staging/dream: add gpio and pmem support
Message-ID: <20091027204445.GA28878@kroah.com>
References: <20091022091333.GA31023@elf.ucw.cz>
 <20091026234332.GB26583@kroah.com>
 <20091027001702.GA5019@elf.ucw.cz>
 <20091027030039.GA6195@kroah.com>
 <20091027081921.GG5019@elf.ucw.cz>
 <20091027165750.GA24477@kroah.com>
 <20091027193330.GB19379@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027193330.GB19379@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 08:33:30PM +0100, Pavel Machek wrote:
> Hi!
> 
> > > Could we perhaps use -I to let it build before I find time to do
> > > search&replace of 100 #includes? Yes, I'm working on that, but no, it
> > > obviously does not progress as fast as I expected...
> > > 
> > > Add missing files/includes neccessary for Dream compilation.
> > >     
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > 
> > Ick, no.  I'm not going to take the wakelock and other header files that
> > are "generic" to android into the dream subdir.  That's not ok.
> 
> What is so wrong with wakelocks? They are just nops in this case.

Are they really?  Then why is the whole large file needed?

> > If this code requires this mess to build, I think we should just delete
> > the whole thing and start over with patches that add code that can
> > actually build properly.
> 
> Well, crap is easier to clean up when it compiles (and is in tree --
> that's point of staging -- right?), and it is not particulary bad crap
> in this case.
> 
> > Any objection to that?
> 
> Yes; dropping the code now will not help anything. Merging it to this
> point was not easy, and forcing me to redo it will just delay me from
> cleaning it up.
> 
> Merging crappy Windows driver to staging is easy:
> 
> 1) you verify it is GPL
> 
> 2) you submit it

Wait, it has to BUILD!  This code has never been able to be built.  Only
after I disabled it from the CONFIG_ANDROID have I noticed this, which
is my fault.  But it needs to get fixed, and taking a bunch of code in
addition to the mess we have now, seems like the wrong way to do it.

> [and then, clean it in tree].
> 
> I tried same process with dream support:
> 
> 1) driver was GPLed
> 
> 2) I tried submitting

It did not BUILD!!!

> 3) I was told to split it according to authors. In Windows driver
> world, that would be show-stopper. Thanks to Google support, I figured
> authors.
> 
> 4) I'm told that -I is not acceptable, not even inside
> staging. Windows drivers regulary have way worse build system
> abuses. (Of course, those need to be fixed before merging into kernel
> proper; fortunately they are easy to do incrementally).

I have never taken a driver in staging that was not self-contained or
needed any -I funkyness.

> Now, I see that wakelocks are show-stopper for merging into kernel
> proper, but what is the problem for staging? We merged drivers with
> OS_MEMORY_ALLOCATE(); wakelocks are just nops in this case.
> 
> Could we please clean this driver in-tree? (Wakelocks are already nops
> due to #ifdef magic, cleaning them incrementally is easy.)

With this patch, will it build properly?

> (Plus, of course I'd like some help, but google people seem very
> silent :-( ).

Google has abandonded upstream Android development, which is a very sad
state of being :(

thanks,

greg k-h
