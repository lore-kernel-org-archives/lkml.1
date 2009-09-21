Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZIUT5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZIUT5L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZIUT5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:57:08 -0400
Received: from eagle.jhcloos.com ([207.210.242.212]:2586 "EHLO
	eagle.jhcloos.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbZIUT5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:57:07 -0400
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 15:57:07 EDT
From: James Cloos <cloos@jhcloos.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: Poor desktop responsiveness with background I/O-operations
In-Reply-To: <1253520364.25640.57.camel@marge.simson.net> (Mike Galbraith's
	message of "Mon, 21 Sep 2009 10:06:04 +0200")
References: <4AB59CBB.8090907@datenparkplatz.de>
	<20090920080728.73bfe2a1@infradead.org>
	<4AB5ECD0.7010903@datenparkplatz.de>
	<1253475521.9224.43.camel@marge.simson.net>
	<4AB6C73C.1030004@gmail.com>
	<1253507034.23414.90.camel@marge.simson.net>
	<4AB72FDC.5090403@datenparkplatz.de>
	<1253520364.25640.57.camel@marge.simson.net>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1.50 (gnu/linux)
Face: iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAI1J
 REFUOE+lU9ESgCAIg64P1y+ngUdxhl5H8wFbbM0OmUiEhKkCYaZThXCo6KE5sCbA1DDX3genvO4d
 eBQgEMaM5qy6uWk4SfBYfdu9jvBN9nSVDOKRtwb+I3epboOsOX5pZbJNsBJFvmQQ05YMfieIBnYX
 FK2N6dOawd97r/e8RjkTLzmMsiVgrAoEugtviCM3v2WzjgAAAABJRU5ErkJggg==
Copyright: Copyright 2009 James Cloos
OpenPGP: ED7DAEA6; url=http://jhcloos.com/public_key/0xED7DAEA6.asc
OpenPGP-Fingerprint: E9E9 F828 61A4 6EA9 0F2B  63E7 997A 9F17 ED7D AEA6
Date: Mon, 21 Sep 2009 15:47:36 -0400
Message-ID: <m3tyyw6pvz.fsf@lugabout.jhcloos.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW, I did not notice any problems with the last kernel I had compiled
in the -- IIRC -- 29-rc timeframe.  Or maybe it was the 30-rc timeframe.

I had that kernel up for soemthing like five weeks, on a busy, low-ram
laptop, w/o and long pauses or other noticeable pain.  For at least two
years before that the best this laptop could manage before latency
became horrific was a fortnight, and weekly reboots were desirable.

Unfortunately, before I could send out a congratulatory note (I wanted
to first confirm that the result remained) I pulled up and started see-
ing even worse latency then ever.

Turning ext4 barriers off helped avoid some of the new latency, and my
current compile (master as of the 17th) is much better than .31 was.

But long pauses still occur whenever paging and backgound i/o-bound
tasks interact.

There was a major regression in paging performance either .30 or .31
(see above).  Interestingly, top(1) also shows less swap usage for
the same usage patterns than with the older kernels.  I don't know
which is cause or which is effect.

A git pull on a clone of Linus' tree is a great way to trigger the
problem.  As is using Gentoo's portage to install/upgrade anything.
(Bad python; no alligator!¹)  (Yes, that is a burlesque of the no
doughnut joke.)

[1] Pythons which have invaded Florida have reportedly been
    witnessed eating alligators, according to a recent wire
    service article.

-JimC
-- 
James Cloos <cloos@jhcloos.com>         OpenPGP: 1024D/ED7DAEA6
