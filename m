Return-Path: <linux-kernel-owner+w=401wt.eu-S1756704AbZBTJoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbZBTJoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 04:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbZBTJoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 04:44:01 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52923 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107AbZBTJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:43:58 -0500
X-Greylist: delayed 744 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Feb 2009 04:43:58 EST
Date: Fri, 20 Feb 2009 09:43:56 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: General question (scheduler) with SSDs?
Message-ID: <20090220094356.GB26124@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whoops, I didn't mean to send that previous half formed mail :) Sorry.

On Thu, Feb 19, 2009 at 08:38:38AM -0500, Justin Piszcz wrote:
> 
> I was curious if anyone had done any benchmarks and/or has conclusive 
> information, what is the best Linux scheduler to use with SSDs?
> 
> Noop?
> CFQ?
> AS?
> Deadline?

As mentioned in another mail there was a discussion on
http://lkml.org/lkml/2009/1/31/28 and long thread talking about the
introduction of the rotational flag here
http://lkml.org/lkml/2009/1/5/340 . Cheapo SSDs or even USB keys are not
auto detected as non-rotational devices by the kernel and after a bit of
poking about I've come up with the following udev rules for my
particular cases:

SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{model}=="ASUS-PHISON *", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"
SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{idVendor}=="0951", ATTRS{idProduct}=="1606", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"
SUBSYSTEM=="block", TEST=="/sys$devpath/queue/rotational", ATTRS{manufacturer}=="SanDisk", ATTRS{product}=="Cruzer Micro", RUN+="/bin/sh -c 'echo 0 > /sys$devpath/queue/rotational'"

Ever since the rotational option appeared I've been trying cfq but prior
to that I was using noop or deadline. However it doesn't look like
anyone has sat down and run the numbers to see what affect the
ioscheulder/rotational flag is having on cheapo SSDs - all the
suggestions are anecdotal. Could you run some benchmarks with these
different options and report back the results?

-- 
Sitsofe | http://sucs.org/~sits/
