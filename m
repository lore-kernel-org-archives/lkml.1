Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbYD3CIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbYD3CIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 22:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYD3CII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 22:08:08 -0400
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:47404
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbYD3CIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 22:08:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4BANdxF0h8qMj2/2dsb2JhbAAIrHs
X-IronPort-AV: E=Sophos;i="4.25,725,1199631600"; 
   d="scan'208";a="322175735"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: David Brownell <david-b@pacbell.net>
Cc: Trent Piepho <tpiepho@freescale.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <200804291804.19518.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	 <200804291455.39674.david-b@pacbell.net>
	 <1209511772.311.55.camel@moss.renham>
	 <200804291804.19518.david-b@pacbell.net>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 30 Apr 2008 12:08:11 +1000
Message-Id: <1209521291.311.99.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-29 at 18:04 -0700, David Brownell wrote:
> On Tuesday 29 April 2008, Ben Nizette wrote:
> > I guess one last option (which is made hard by chip label non-uniqueness
> > but I'll throw out anyway) would be
> > 
> > /sys/class/gpio
> >         /chipa
> >                 /gpio-n
> >                         /value
> >                         /direction
> >                 /control
> >         /chipb
> >                 :
> >                 :
> > 
> 
> Or maybe:
> 
>   /sys/class/gpio
> 	/gpiochip-X			<-- range X..(X+ngpio)
> 		/device			<-- symlink, if it's known
> 		/ngpio
> 		/label
> 		/start			<-- maybe; start == X
> 
> with the gpio-N links probably going where you showed.  That'd be
> best in terms of Purity Of Essence.

So you're suggesting that the gpio-N links and control file live inside
the gpiochip-X folder along with info about the chip to which they're
attached?  I don't mind this, sounds good.  Certainly feels most
sysfsish.

Scripting would be pretty simple assuming there's one control file per
chip and the gpio number written to said control file is relative to
that chip's base.  i.e. finding pcf9557:5 (assuming only one such
device) would just be

- find the gpiochip-X folder whose /label == pcf9557
- echo "export 5" > <that_folder>/control
- read/write <that_folder>/gpio-5/{value,direction}

If you've got multiple pca9557s then you're always going to have a hard
time distinguishing them but you've been given all the information
available to allow you to discover which is which.

In fact more than enough; if the base is dynamically allocated then you
don't know what to expect /start to be, you know what /ngpio will be and
you never need to find the full gpio number so those 2 files are
redundant yeah?

--Ben.

