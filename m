Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbZAEXD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbZAEXD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 18:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750889AbZAEXDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 18:03:49 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:18782 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZAEXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 18:03:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=nNlmCRc2l4+qG8zEiWwzx6wINlAR9JkIEKvf9MULqHzWLfo+0nhCzeDbu5OIV3GAov
         uW0NNa5rT1mA095LCwPcrusC79mta46dr1DcXD3/bQfKoINbSm4YzsOqgYTgcszJpg12
         ZHzvyIF2dII4Tv7EjZ3Jfhn3Yl61Kd1ykfZvY=
Message-ID: <3ae3aa420901051503s129c3cc0kb022d42f21550099@mail.gmail.com>
Date: Mon, 5 Jan 2009 17:03:45 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "David Newall" <davidn@davidnewall.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Ben Goodger" <goodgerster@gmail.com>, david@lang.hm,
       "Kyle Moffett" <kyle@moffetthome.net>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net
In-Reply-To: <4961A9E2.9060601@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <4960897D.5030603@davidnewall.com>
	 <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	 <4961432A.80509@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
	 <alpine.DEB.1.10.0901041702540.25545@asgard.lang.hm>
	 <496150DF.2070501@davidnewall.com>
	 <8752a8760901041621o51380e91x9ef8414b22c40ffc@mail.gmail.com>
	 <4961A9E2.9060601@davidnewall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/5 David Newall <davidn@davidnewall.com>:

> Zoneinfo files cater for leap seconds.

As has been (repeatedly) pointed out, the leap seconds
only apply to UTC, so there is no way, given UTC, to
use a zoneinfo file to twiddle UTC.

Your argument *might* work if the kernel maintained
TEI instead of UTC. Then there could, in principle, be
a zoneinfo file that converted from TEI to UTC (by
adding 24 seconds to TEI).

However, this requires converting the kernel to track
TEI instead of UTC, and reviewing all sorts of code
in the kernel, glibc, ntp, and myriads of other libraries
to figure out what's affected and whats not. As well
as figuring out how to twiddle zoneinfo files so that
they're backwards/forwards compatible with the
timekeeping change, so that users aren't screwed
when they put new kernels on old distros, or new
zonefiles on old kernels.

This is a fairly big chunk of work, requiring coordination
between lots of different parties.

> If you know in advance, you can update zoneinfo files with multiple leap
> seconds.

Heh. You miss the point. The whole point of leap seconds
is that they're unknowable in advance. You only know if they
already happened, or seem likely to happen real soon now.
The previously cited wikipedia article reviews this nicely.

--linas

p.s. Yes, you could say I'm coming around to your point
of view.  If you had said, from the begining, something
like "the kernel should keep TEI instead of UTC, and
compute UTC in user-space from the TEI time", then
you might have met a lot less resistance.  But that's not
how your argument came across.
