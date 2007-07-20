Return-Path: <linux-kernel-owner+w=401wt.eu-S937350AbXGTReJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937350AbXGTReJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 13:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936834AbXGTRd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 13:33:26 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54252 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936682AbXGTRdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 13:33:23 -0400
Date: Fri, 20 Jul 2007 11:33:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Denis Cheng <crquan@gmail.com>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] run scripts/Lindent on it to match Documentation/CodingStyle
Message-ID: <20070720173322.GG14791@parisc-linux.org>
References: <1184489571313-git-send-email-crquan@gmail.com> <4699EEA9.6070709@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4699EEA9.6070709@simon.arlott.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 15, 2007 at 10:53:45AM +0100, Simon Arlott wrote:
> > -	} else if (base_addr > 0x100) { /* Check a single specified location. */
> > +	} else if (base_addr > 0x100) {	/* Check a single specified location. */
> 
> What is Lit doing here?! It's changed "{<space>/*" to "{<tab>/*"...
> 
> > -	} else { /* Scan all possible addresses of the WaveLAN hardware. */
> > +	} else {		/* Scan all possible addresses of the WaveLAN hardware. */
> 
> And again... with two tabs for maximum unreadability. That line is now
> 90 characters long instead of 75.

There's two things going on here.  One is that we haven't told indent to
cram the comments after code up against the code -- by default it will
move the comment out to start in column 33.  We can override that by
adding '-c1' to the Lindent line.

The other is that, even when you do that, it only wants to indent
comments with tabs.  So in this example:

int bar(void)
{
        if (x) {
        } else if (quite_a_long_conditional_which) { /* takes up a lot of ram */
        } else { /* An absolutely gargantuan comment that heads to the end */
        } /* Another comment */
}

by default Lindent will move the comment to:

        } else if (quite_a_long_conditional_which) {    /* takes up a lot of ram */
        } else {                /* An absolutely gargantuan comment that heads to the end */
        }                       /* Another comment */

adding -c1 gets us:

        } else if (quite_a_long_conditional_which) {    /* takes up a lot of ram */
        } else {        /* An absolutely gargantuan comment that heads to the end */
        }       /* Another comment */

but the indent manpage is quite definite:

       If the code to the left of the comment exceeds  the  beginning  column,
       the comment column will be extended to the next tabstop column past the
       end of the code, or in the case  of  preprocessor  directives,  to  one
       space past the end of the directive.

I suppose someone could add a new option to indent to change that, but
I'd rather see people not put comments there, tbh.

> > -				       "%s: <-wavelan_probe()\n",
> > -				       dev->name);
> > +				       "%s: <-wavelan_probe()\n", dev->name);
> 
> There are spaces in that line after the tabs...

I think that's to make it line up with the beginning of the function arguments.
Can't tell cos you snipped that bit ;-)

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
