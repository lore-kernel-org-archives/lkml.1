Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXKQRgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXKQRgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 12:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbXKQRg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 12:36:29 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:42911 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755430AbXKQRg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 12:36:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mX9rqSkP1IDRxI1k5Kee0cPaHKw6TE3Whrw9lKKNZehJW47kzryAwBbCkC7H+T/3AXcNrjf4S+XuLkGv11y2dvYuK2nMx+fHMc2drwE5sP3c6oLZ9YGMFH94i4FnWZItE0Db7zsngIu8iQqzHfEt2Mi/ACVVA19Bnr8WatiHY2I=  ;
X-YMail-OSG: x6TTG94VM1kDuGtKQoaPYQXtoS4NP1TIWJrz5BRr.JkJYxTl.1AhtY0o5EJFjxKv3kfCRSEaSA--
From: David Brownell <david-b@pacbell.net>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Sat, 17 Nov 2007 09:36:24 -0800
User-Agent: KMail/1.9.6
Cc: "eric miao" <eric.y.miao@gmail.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Kevin Hilman" <khilman@mvista.com>,
       "Paul Mundt" <lethal@linux-sh.org>, "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711132036.14927.david-b@pacbell.net> <20071117113855.7532e477@hyperion.delvare>
In-Reply-To: <20071117113855.7532e477@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711170936.25524.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 November 2007, Jean Delvare wrote:
> On Tue, 13 Nov 2007 20:36:13 -0800, David Brownell wrote:
> > On Tuesday 13 November 2007, eric miao wrote:
> > >  	if (!requested)
> > > -		printk(KERN_DEBUG "GPIO-%d autorequested\n",
> > > -				chip->base + offset);
> > > +		pr_debug("GPIO-%d autorequested\n", gpio);
> > 
> > Leave the printk in ... this is the sort of thing we want
> > to see fixed, which becomes unlikely once you hide such
> > diagnostics.  And for that matter, what would be enabling
> > the "-DDEBUG" that would trigger a pr_debug() message?
> 
> The original code isn't correct either.

It's perfectly correct.  That it's an idiom you don't
seem to *like* but is distinct from correctness.


> Either this is a debug message 
> and indeed pr_debug() should be used, or it's not and KERN_DEBUG should
> be replaced by a lower log level.

KERN_DEBUG is what says the message level is "debug".
Both styles log messages at that priority level.

Which is distinct from saying that the message should
vanish from non-debug builds ... that's what pr_debug
and friends do, by relying implicitly on "-DDEBUG".

In this case, the original code was saying that the
message should NOT just vanish.  One reason the patch
was incorrect was that even on its own terms, it was
wrong ... since it used the "-DDEBUG" mechanism wrong,
and prevented the message from *EVER* appearing.

- Dave
