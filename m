Return-Path: <linux-kernel-owner+w=401wt.eu-S1759831AbYD3KeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759831AbYD3KeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756148AbYD3Kdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:33:52 -0400
Received: from outbound.icp-qv1-irony-out4.iinet.net.au ([203.59.1.150]:31864
	"EHLO outbound.icp-qv1-irony-out4.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755750AbYD3Kdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:33:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4BAH/nF0h8qMj2/2dsb2JhbAAIrG8
X-IronPort-AV: E=Sophos;i="4.25,727,1199631600"; 
   d="scan'208";a="214130818"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804292003440.24287@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net>
	 <200804291455.39674.david-b@pacbell.net>
	 <1209511772.311.55.camel@moss.renham>
	 <200804291804.19518.david-b@pacbell.net>
	 <1209521291.311.99.camel@moss.renham>
	 <Pine.LNX.4.64.0804292003440.24287@t2.domain.actdsltmp>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 30 Apr 2008 20:33:47 +1000
Message-Id: <1209551627.3641.12.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-29 at 20:13 -0700, Trent Piepho wrote:
> On Wed, 30 Apr 2008, Ben Nizette wrote:
> >
> > So you're suggesting that the gpio-N links and control file live inside
> > the gpiochip-X folder along with info about the chip to which they're
> > attached?  I don't mind this, sounds good.  Certainly feels most
> > sysfsish.
> >
> > Scripting would be pretty simple assuming there's one control file per
> > chip and the gpio number written to said control file is relative to
> > that chip's base.  i.e. finding pcf9557:5 (assuming only one such
> > device) would just be
> >
> > - find the gpiochip-X folder whose /label == pcf9557
> > - echo "export 5" > <that_folder>/control
> > - read/write <that_folder>/gpio-5/{value,direction}
> 
> I don't suppose you could actually write the code to do this?
> 
> I already wrote the code, and am using it, for the way I have it work.
> 
> cat /sys/class/gpio/pcf9557-0:5
> 
> But I guess this is too easy.  "We can't have any of that!!  The Earth will
> turn in its grave!  And Slashdot will be decorated in Pink!  Teh End Daze
> arrive!  :)"
> 

I'm sure I could but I'd prefer to have us all come (as close as
possible) to an agreed theoretical interface first :-)

What you've got working there is nice but it still downsides (unless you
can set me straight).  First, we still have the problem of either 100s
of unused files or an index to use in a request.  Also, if you've got
many pcf9557s in a system you'll have a bunch of pcf9557-n; how do you
know which is which?

I think with the above solution we're coming very close to a sexy
system.  We don't need an index file, we have all the information we
need to find which device is which, there's no need to calculate any
full gpio number, there's no files which aren't going to be used, it's
safe, extensible, scriptable, sysfsish..  Am I missing anything?

--Ben
