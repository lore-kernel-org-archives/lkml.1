Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbZAGRlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbZAGRlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 12:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbZAGRlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 12:41:44 -0500
Received: from bsdimp.com ([199.45.160.85]:50744 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZAGRln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 12:41:43 -0500
Date: Wed, 07 Jan 2009 10:39:47 -0700 (MST)
Message-Id: <20090107.103947.1324582654.imp@bsdimp.com>
To: mayer@ntp.isc.org
Cc: linasvepstas@gmail.com, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <49642674.9080703@ntp.isc.org>
References: <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	<3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	<49642674.9080703@ntp.isc.org>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <49642674.9080703@ntp.isc.org>
            Danny Mayer <mayer@ntp.isc.org> writes:
: Why don't you tell us what the real problem is instead of telling us
: that you need TAI offset information?

The real problem is that POSIX time_t totally ignores leap seconds.
This forces systems that are rolling through a leap second to repeat
time, causing time to jump backwards by 1s (or violate POSIX time_t's
invariant that midnight time_t is % 86400 == 0).  This jump backwards
is a pita in the kernel, and violates the assumption that many
programs have that time doesn't flow backwards.

The suggestion to solving this would be to tick in TAI time, and force
userland to cope with the leapsecond issues.  Of course, there's a
number of problems with this solution as well, but it feels like it
belongs there...

Warner
