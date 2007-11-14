Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbXKNQOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbXKNQOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:14:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756559AbXKNQOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:14:08 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:52247 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbXKNQOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:14:07 -0500
Date: Wed, 14 Nov 2007 08:13:25 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: William Cohen <wcohen@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114161325.GL6557@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com> <20071114020702.GB20365@one.firstfloor.org> <20071114130909.GB6557@frankl.hpl.hp.com> <20071114142411.GD17145@one.firstfloor.org> <473B17D4.5050702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473B17D4.5050702@redhat.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Nov 14, 2007 at 10:44:20AM -0500, William Cohen wrote:
> Andi Kleen wrote:
> 
> >>One approach does not prevent the other. Assuming you allow cr4.pce, then 
> >>nothing prevents
> >>a self-monitoring thread from reading the counters directly. You'll just 
> >>get the
> >>lower 32-bit of it. So if you read frequently enough, you should not have 
> >>a problem.
> >
> >Hmm? RDPMC is 64bit.
> 
> There are a number of processors that have 32-bit counters such as the IBM 
> power processors. On many x86 processors the upper bits of the counter are 
> sign extended from the lower 32 bits. Thus, one can only assume the lower 
> 32-bit are available. Roll over of values is quite possible (<2 seconds of 
> cycle count), so additional work needs to be done to obtain a valid value.
> 

Exactly, on Intel's only the bottom 32-bit actually are useable, the rest is
sign-extension. That's why it is okay for measuring small sections of code,
but that's it. On AMD, I think it is better. On Itanium you get the 47-bit worth.
Don't know about Power or Cell.

-- 
-Stephane
