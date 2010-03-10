Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0CJO2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 09:28:20 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36299 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab0CJO2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 09:28:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xtER4DwrGAJZ4T8Fq1FmCSpgdX7gka2goZ2FBhj2m8mlrMyX6R9umLDMjtjClm3TLb
         fqXjBnH6q9LH/GhCKQMEXgkyfRaAk2DewS2QaYJuXja/u4GLzzlh8qYSCCQrmh01Q1RE
         dj/RR7yKCvr+lBCtv4+KrGVPsHsNs6ceJ+taQ=
Date: Wed, 10 Mar 2010 17:27:59 +0300
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: smatch_scripts/whitespace_only.sh
Message-ID: <20100310142759.GG6321@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>, linux-kernel@vger.kernel.org,
	gregkh@suse.de, kernel-janitors@vger.kernel.org,
	devel@driverdev.osuosl.org
References: <20100310101224.GC6321@bicker> <Pine.LNX.4.64.1003101113330.24684@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1003101113330.24684@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 11:14:53AM +0100, Julia Lawall wrote:
> On Wed, 10 Mar 2010, Dan Carpenter wrote:
> 
> > I wrote a script to check that a patch only changes white space.
> > It compiles the files before and after the patch is applied and 
> > verifies that they are the same.
> > 
> > You'll need to compile smatch:
> > 	git pull git://repo.or.cz/smatch.git
> > 	make
> > 	cd /path/to/kernel/src/
> > 	/path/to/smatch_scripts/whitespace_only.sh <patch>
> > 
> > Adding or removing parenthesis and curly braces counts as a code 
> > change.  Changes to comments, #if 0, white space changes do not.
> > 
> > You can fix a lot of style violations if you limit yourself to 
> > adding and removing tabs, spaces and new lines.  Then the next 
> > patch could remove unneeded parenthesis.  It would be easier to
> > audit that way instead of everything mixed together.
> > 
> > regards,
> > dan carpenter
> > 
> > PS.  I feel really bad slagging the newbies trying to help.  
> > Could we fix checkpatch.pl to not complain about line lengths?
> 
> I hope not...  Are newbies really put off by having to add a newline here 
> and there?
> 
> julia
> 

The problem is that newbies are only too happy to chop lines up into smaller 
and smaller bits.  :P  I've seen situations where the actual author of the code
broke up _his own_ perfectly reasonable code into tiny chunks just to satisfy 
checkpatch.pl.

				printk("blah blah blah blah"
						"blah blah"
						"blah");

It would be great if people dealt with checkpatch warnings by breaking
things out into separate functions and eliminating indent levels but 
that never happens.

regards,
dan carpenter

ps: Emacs starts with an 80 character window by default.  On my login
I have a ~/bin/emacs shell script that invoke real emacs as full screen.

#!/bin/sh
/usr/bin/emacs -fh -fw --no-splash $@

