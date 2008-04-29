Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYD2Mfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYD2Mfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYD2Mf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:35:26 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:10252
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbYD2MfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:35:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8BAJayFkh8qMj2/2dsb2JhbAAIrFc
X-IronPort-AV: E=Sophos;i="4.25,722,1199631600"; 
   d="scan'208";a="255942499"
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
From: Ben Nizette <bn@niasdigital.com>
To: Trent Piepho <tpiepho@freescale.com>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804282202340.8286@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net>
	 <Pine.LNX.4.64.0804281507160.6832@t2.domain.actdsltmp>
	 <200804281745.59442.david-b@pacbell.net>
	 <Pine.LNX.4.64.0804282202340.8286@t2.domain.actdsltmp>
Content-Type: text/plain
Organization: Nias Digital
Date: Tue, 29 Apr 2008 22:35:26 +1000
Message-Id: <1209472526.311.50.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 22:48 -0700, Trent Piepho wrote:
> On Mon, 28 Apr 2008, David Brownell wrote:
> > On Monday 28 April 2008, Trent Piepho wrote:
> >> On Mon, 28 Apr 2008, David Brownell wrote:
> >>> Simple sysfs interface for GPIOs.
> >>>
> >>>    /sys/class/gpio
> >>>        /gpio-N ... for each exported GPIO #N
> >>
> >> I liked it better they way I had it, "label:N".
> >
> > Those labels may not be available though; or valid in pathnames.
> 
> So just fall back to "gpio" if there is no label?  The only character that's
> not valid in a pathname is '/', so that's trivial to check for.
> 
> const char *label = chip->label && !strchr(chip->label, '/') ?
>  	chip->label : "gpio"; /* or "generic" or "unknown", or ...*/
> 
> This means you don't need a file with number to device assignents.  It makes
> shell scripting a lot easier too.  Say I want the first gpio on a pca9557 gpio
> expander?  It's will be something like:  /sys/class/gpio/pca9557-0:0
> 
> You don't have to worry about dynamic assigments.  You don't have to resort to
> convoluted shell script code to extract the proper range from a mapping file
> and then construct the name.

Sorry if I'm being dense; how do you want this bit to work?  As I see
it, there are a few options:

1) Have the files named as you suggest and all of them always present,
albeit read-only until export.  Very easy to use, easy to discover which
file is which, a decent bit of memory usage having them all listed.

2) Have the files named as you suggest and you have to explicitly
request them or have the kernel explicitly export them.  To request them
yourself you're going to need the gpio number so having the created file
labelled nicely isn't a win over having it labelled with the gpio
number.  I 'spose there's a win for kernel exported gpios, they're more
human readable, but you're still going to have to have the mappings
available somewhere for the manually exported gpios anyway.

3) Have the files named as you suggest, explicit export/request but
better parsing behind the control file so something like
echo "export pca9557-0:5" > control
works.  Very very nice for the user, big heavy back end.

4) Status quo.  Easy, efficient, potentially hard to discover which gpio
you actually want.

My vote's for 1 or 4.  The first one is heavier but easier.  The last
one will need something like the discussed file mapping ranges to gpios.
Do your expectations/ideas fit in cleanly anywhere above?

Thanks,
	--Ben  

