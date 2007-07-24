Return-Path: <linux-kernel-owner+w=401wt.eu-S1762151AbXGXRWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762151AbXGXRWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755936AbXGXRWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:22:48 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:42293 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbXGXRWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:22:47 -0400
Date: Wed, 25 Jul 2007 02:22:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.08
Message-ID: <20070724172217.GA10725@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>,
	"Kok, Auke" <auke-jan.h.kok@intel.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
References: <740c90243aaa6f6d4640d71230c4fa27@pinky> <46A534EA.6030008@intel.com> <46A5C12B.3080904@shadowen.org> <20070724021526.3d92286b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724021526.3d92286b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 02:15:26AM -0700, Andrew Morton wrote:
> On Tue, 24 Jul 2007 10:06:51 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
> 
> > > This is a royal pain, since it now throws an ERROR for the obviously
> > > preferable piece of code below:
> > > 
> > > if (err) {
> > >     do_something();
> > >     return -ERR;
> > > } else {
> > >     do_somthing_else();
> > > }
> > 
> > Hmmm, is that obviouly nicer than the below?  Its fully a line longer
> > for no benefit.  But ignoring that, this seems to have snuck in to
> > CodingStyle hmmm ... will see what I can do if anything to stop these
> > being picked up I guess.
> > 
> > 	if (err) {
> > 		do_something();
> > 		return -ERR;
> > 	} else
> > 		do_something_else();
> 
> The kool kids on linux-usb-devel largely ended up deciding that the second
> version looks dorky.
> 
Since when did linux-usb-devel decide stylistic nits of the rest of the
kernel? Let them do what they want in drivers/usb, I have a hard time
accepting that what someone arbitrarily decides they want to do in their
directory suddenly blanketly applies to the rest of the kernel, and
therefore warrants a CodingStyle update.

Perhaps CodingStyle can start being versioned, so people can opt out of
certain 'improvements' whenever someone has a vision, much like some
nameless licenses.

Personally I prefer the second style, and if there's a comment block,
then it makes sense to complete the tree with {}'s (the keyword here is
prefer, as it's a personal preference). checkpatch has been quite useful
for catching obviously broken things, and now it seems like it's just
overreaching. Perhaps this functionality can be split in to a lite
checkpatch for catching show-stoppers for application and then something
more akin to a CodingStyle validator for the folks interested in
arbitrarily defining convention, which they can use freely while the rest
of us try to get something useful done.
