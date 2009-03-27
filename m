Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZC0QRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZC0QRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbZC0QRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:17:16 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35268 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753961AbZC0QRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:17:15 -0400
Date: Fri, 27 Mar 2009 16:15:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327161553.31436545@lxorguk.ukuu.org.uk>
In-Reply-To: <20090327152221.GA25234@srcf.ucam.org>
References: <20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090327032301.GN6239@mit.edu>
	<20090327034705.GA16888@srcf.ucam.org>
	<20090327051338.GP6239@mit.edu>
	<20090327055750.GA18065@srcf.ucam.org>
	<20090327062114.GA18290@srcf.ucam.org>
	<20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> No. Not *having* to check for errors in the cases that you care about is 
> progress. How much of the core kernel actually deals with kmalloc 
> failures sensibly? Some things just aren't worth it.

I'm glad to know thats how you feel about my data, it explains a good
deal about the state of some of the desktop software. In kernel land we
actually have tools that go looking for kmalloc errors and missing tests
to try and check all the paths. We run kernels with kmalloc randomly
failing to make sure the box stays up: because at the end of the day
*kmalloc does fail*. The kernel also tries very hard to keep the fail
rate low - but this doesn't mean you don't check for errors.

Everything in other industry says not having to check for errors is
missing the point. You design systems so that they do not have error
cases when possible, and if they have error cases you handle them and
enforce a policy that prevents them not being handled.

Standard food safety rules include 

Labelling food with dates
Having an electronic system so that any product with no label cannot
escape
Checking all labels to ensure nothing past the safe date is sold
Having rules at all stages that any item without a label is removed and
is flagged back so that it can be investigated

Now you are arguing for "not having to check for errors"

So I assume you wouldn't worry about food that ends up with no label on
it somehow ?

Or when you get a "permission denied" do you just assume it didn't
happen ? If the bank says someone has removed all your money do you
assume its an error you don't need to check for ?

The two are *not* the same thing.

You design failure out when possible
You implement systems which ensure all known failure cases must be handled
You track failure rates to prove your analysis
Where you don't handle a failure (because it is too hard) you have
detailed statistical and other analysis based on rigorous methodologies
as to whether not handling it is acceptable (eg ALARP)

and unfortunately at big name universities you can still get a degree or
masters even in software "engineering" without actually studying any of
this stuff, which any real engineering discipline would consider basic
essentials.

How do we design failure out
- One obvious one is to report out of disk space on write not close. At
  the app level programmers need to actually check their I/O returns
  because contrary to much of todays garbage software (open and
  proprietary) or use languages which actually tell them off if each
  exception case is not caught somewhere

- Use disk and file formats that ensure across a failure you don't
  suddenly get random users medical data popping up post reboot in
  index.html or motd. Hence ordered data writes by default (or the same
  effect)

- Writing back data regularly to allow for the fact user space
  programmers will make mistakes regardless. But this doesn't mean they
  "don't check for errors"

And if you think an error check isn't worth making then I hope you can
provide the statistical data, based on there being millions of such
systems and in the case of sloppy application writing where the result
is "oh dear where did the data go" I don't think you can at the moment.

To be honest I don't see your problem. Surely well designed desktop
applications are already all using nice error handling, out of space and
fsync aware interfaces in the gnome library that do all the work for them
- "so they don't have to check for errors".

If not perhaps the desktop should start by putting their own house in
order ?

Alan
