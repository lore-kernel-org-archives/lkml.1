Return-Path: <linux-kernel-owner+w=401wt.eu-S932108Ab0AETYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0AETYV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:24:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370Ab0AETYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:24:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43001 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0AETYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:24:17 -0500
X-Authority-Analysis: v=1.0 c=1 a=lN5U_OXkO8kA:10 a=7U3hwN5JcxgA:10 a=qm_4pMOoXpPK0yWy5g8A:9 a=IMwPLCvjyQSrRdqAdfCbPnRhuGMA:4 a=v7YQ8PUSAOOxQ4ax:21 a=-0C7IE-D2e8qUr9i:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2] tracing/recordmount.pl: use apropriate
 perl-constructs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20100105191306.GA4848@pengutronix.de>
References: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de>
	 <1262716072-14414-2-git-send-email-w.sang@pengutronix.de>
	 <1262716072-14414-3-git-send-email-w.sang@pengutronix.de>
	 <1262716675.28171.1612.camel@gandalf.stny.rr.com>
	 <20100105191306.GA4848@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 05 Jan 2010 14:24:15 -0500
Message-ID: <1262719455.28171.1663.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-05 at 20:13 +0100, Wolfram Sang wrote:
> > > -$objdump = "objdump" if ((length $objdump) == 0);
> > > -$objcopy = "objcopy" if ((length $objcopy) == 0);
> > > -$cc = "gcc" if ((length $cc) == 0);
> > > -$ld = "ld" if ((length $ld) == 0);
> > > -$nm = "nm" if ((length $nm) == 0);
> > > -$rm = "rm" if ((length $rm) == 0);
> > > -$mv = "mv" if ((length $mv) == 0);
> > > +$objdump ||= 'objdump';
> > > +$objcopy ||= 'objcopy';
> > > +$cc ||= 'gcc';
> > > +$ld ||= 'ld';
> > > +$nm ||= 'nm';
> > > +$rm ||= 'rm';
> > > +$mv ||= 'mv';
> > 
> > I purposely did not do it this way (I need to add a comment about this),
> > because most kernel developers are not perl programmers, and I wanted
> > this to be as easy as possible for a non-perl programmer to understand.
> > 
> > Even as a perl programmer it still looks funny to me with the:
> > 
> > 
> >   $x ||= 'x';
> > 
> 
> Yes, okay, it's an idiom one needs to know. While your point "be C-compatible"
> makes also sense to me (comment would be nice indeed), this should do it, too?
> 
> 	$cc = "gcc" if ($cc == '');

Yeah that looks better. You can also add a comment that says that this
code is trying to be C programmer friendly, and avoids the "$x ||= 'x'"
construct. Since this is the second or third time I had to deny that
change ;-)

> 
> > >  # Shut up recordmcount if user has older objcopy
> > > -my $quiet_recordmcount = ".tmp_quiet_recordmcount";
> > > -my $print_warning = 1;
> > > -$print_warning = 0 if ( -f $quiet_recordmcount);
> > > +my $quiet_recordmcount = '.tmp_quiet_recordmcount';
> > > +my $print_warning = (! -f $quiet_recordmcount);
> > 
> > Again, this is just using perl obfuscation for most C programmers to
> > understand.
> 
> Okay, mileages... :)
> 
> > I fine with this change too.
> 
> Shall I resend or will you just pick up the interesting parts?

Yes please resend!

Thanks,


-- Steve


