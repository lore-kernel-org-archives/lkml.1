Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbZCBT6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbZCBT6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 14:58:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZCBT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 14:57:53 -0500
Received: from thunk.org ([69.25.196.29]:42473 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbZCBT5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 14:57:52 -0500
Date: Mon, 2 Mar 2009 14:57:25 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mark Brown <broonie@sirena.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Warn on empty commit log bodies
Message-ID: <20090302195725.GB25469@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mark Brown <broonie@sirena.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
References: <49A9C252.50204@s5r6.in-berlin.de> <20090301001829.GA10751@mit.edu> <20090301004618.GA12909@sirena.org.uk> <20090301025357.GC10751@mit.edu> <20090302131514.GC19744@sirena.org.uk> <49ABF825.1010501@s5r6.in-berlin.de> <20090302100158.bb83bec6.akpm@linux-foundation.org> <20090302182456.GF19744@sirena.org.uk> <20090302103437.f3109332.akpm@linux-foundation.org> <20090302191910.GG19744@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090302191910.GG19744@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02, 2009 at 07:19:11PM +0000, Mark Brown wrote:
> I'm not sure that simply supplying a body would help anything here, FWIW
> - if I'm writing a body for the sake of it it'll generally just be
> repetitive which isn't terribly constructive.  Obviously I do *try* to
> write sensible changelogs and will keep making an effort to do so.  As
> far as I remember most of the issues in the past have been due to
> missing out something along the lines of "...because that's what the
> silicon does" but ICBW.

If you mean stuff like this:

    commit a39a021fd73ce06aad8d1081ac711a36930e6cb8
    Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
    Date:   Wed Feb 4 21:10:58 2009 +0100

        mfd: Mark WM835x USB_SLV_500MA bit as accessible
        
        The code is out of sync with the silicon.
        
        Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
        Signed-off-by: Samuel Ortiz <sameo@openedhand.com>

What I wouldn't know, looking at the message, and what I suspect
Andrew is complaining about, is after reading the entire commit log,
"So what?"  Is it going to cause the the device to explode?  Will the
system crash?  Will the device go nonfunctional until you power cycle
it?  What will the user see before this patch is applied?

Maybe it's obvious to you, since you know the device, but it's not
obvious to the rest of us.   This in contrast to a commit log such as:

subsys: Add error checking to kmalloc() call

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

... where all good kernel developers should understand the
consequences of not checking the return value to kmalloc().  But do
you really expect most kernel developers to know what the heck a
USB_SLV_500MA bit means, and what it means for it to be "accessible"
versus "not accessible"?

   "Always write with a deep sympathy for the reader"
   	   	      	     Will Strunk, Elements of Style

		     	  	  	   - Ted
