Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZC0OJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZC0OJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752947AbZC0OI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:08:59 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42191 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752368AbZC0OI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:08:58 -0400
Date: Fri, 27 Mar 2009 14:06:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frans Pop <elendil@planet.nl>, mjg@redhat.com, tytso@mit.edu,
       mingo@elte.hu, jack@suse.cz, akpm@linux-foundation.org,
       arjan@infradead.org, a.p.zijlstra@chello.nl, npiggin@suse.de,
       jens.axboe@oracle.com, drees76@gmail.com, jesper@krogh.cc,
       linux-kernel@vger.kernel.org, oleg@redhat.com, roland@redhat.com
Subject: Re: [PATCH 2/2] Make relatime default
Message-ID: <20090327140640.5aa99535@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.0903261728170.3994@localhost.localdomain>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
	<20090326113705.GV32307@mit.edu>
	<20090326140312.GB14822@elte.hu>
	<20090326144707.GA6239@mit.edu>
	<alpine.LFD.2.00.0903260914440.3032@localhost.localdomain>
	<20090326170714.GF6239@mit.edu>
	<alpine.LFD.2.00.0903261015050.3032@localhost.localdomain>
	<20090326174956.GB7198@srcf.ucam.org>
	<20090326175314.GC7198@srcf.ucam.org>
	<20090326184838.26166549@lxorguk.ukuu.org.uk>
	<20090326184838.26166549@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0903261525560.3032@localhost.localdomain>
	<200903270115.32071.elendil@planet.nl>
	<alpine.LFD.2.00.0903261728170.3994@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why? RELATIME has been around since 2006 now.

The workable fixes to relatime (the always update once per 24 hours) you
only just comitted - and did come from a vendor.

It also looks btw that we don't want to have a "relatime" option and a
"strictatime" option and a "relatimebutdoitevery24hrs" option.

All three of these are the same thing so it should (regardless of default
choice) be 

	relatime=n

	n = 0 ('update if its more than 0 seconds out of date') =
	strictatime
	n = MAXINT (basically equals relatime)
	n = 24hrs (the new 'fixed' relatime but not too relative)

	n = anything else - user tuned

Alan
