Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbZAGTdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbZAGTdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbZAGTdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:33:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59522 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757330AbZAGTdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:33:32 -0500
Date: Wed, 7 Jan 2009 19:31:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "M. Warner Losh" <imp@bsdimp.com>
Cc: mayer@ntp.isc.org, linasvepstas@gmail.com, david@lang.hm, hancockr@shaw.ca,
       kyle@moffetthome.net, slashdot@jameshallam.info, goodgerster@gmail.com,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
Message-ID: <20090107193127.0bec8ad8@lxorguk.ukuu.org.uk>
In-Reply-To: <20090107.103947.1324582654.imp@bsdimp.com>
References: <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
	<3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	<49642674.9080703@ntp.isc.org>
	<20090107.103947.1324582654.imp@bsdimp.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> time, causing time to jump backwards by 1s (or violate POSIX time_t's
> invariant that midnight time_t is % 86400 == 0).  This jump backwards
> is a pita in the kernel, and violates the assumption that many
> programs have that time doesn't flow backwards.

They can slew the clock slowly as well. There is a wonderful quote from
one of the summaries of the POSIX committee discussions on time that says
quite simply "the posix clock is not guaranteed to be accurate"

As it currently stands the kernel contains sufficient support that at the
point you know a leap second is coming you can adjust the second length
marginally over the entire period.

The current behaviour is an implementation decision. Jumping on a second
shouldn't be an issue to most people, jumping back is asking for badness
but isn't in fact used in the world today. Slewing the entire day so that
each second is 1/86400 of a second longer or shorter wouldn't be noticed
by anyone.

Alan
