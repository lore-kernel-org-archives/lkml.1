Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbYKYSjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbYKYSjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 13:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752657AbYKYSjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 13:39:43 -0500
Received: from hobbit.corpit.ru ([81.13.33.150]:23408 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYKYSjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 13:39:42 -0500
Message-ID: <492C466A.7070200@msgid.tls.msk.ru>
Date: Tue, 25 Nov 2008 21:39:38 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: Eric Sandeen <sandeen@sandeen.net>, Stian Jordet <liste@jordet.net>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alan Piszcz <ap@solarrain.com>
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
References: <1226760254.5089.11.camel@chevrolet> <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com> <1227476908.32357.5.camel@chevrolet> <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan> <1227485956.5145.10.camel@chevrolet> <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan> <1227569808.5039.6.camel@chevrolet> <492B5684.2080107@sandeen.net> <alpine.DEB.1.10.0811250456010.16346@p34.internal.lan>
In-Reply-To: <alpine.DEB.1.10.0811250456010.16346@p34.internal.lan>
X-Enigmail-Version: 0.95.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
[]
> barriers enabled:
> real    2m40.643s
> barriers disabled:
> real    0m27.612s

Barriers enabled:

$ time sh -c "tar xf linux-2.6.27.tar.bz2; sync"
real	2m3.317s
user	0m33.990s
sys	0m3.980s

$ time sh -c "rm -rf linux-2.6.27; sync"
real	1m4.033s
user	0m0.080s
sys	0m2.860s


Barriers disabled:

$ time sh -c "tar xf linux-2.6.27.tar.bz2; sync"
real	0m36.279s
user	0m25.610s
sys	0m2.800s

$ time sh -c "rm -rf linux-2.6.27; sync"
real	0m3.694s
user	0m0.010s
sys	0m2.230s


During unpack, with barriers=on, the cpu usage stays
hardy noticeable, while with barriers=off, the thing
becomes CPU-bound (needed for bzip2).

For comparison, here are results for jfs on the
same drive:

$ time sh -c "tar xf /stage/build/kernel/linux-2.6.27.tar.bz2; sync"
real	0m36.062s
user	0m25.370s
sys	0m2.860s

$ time sh -c "rm -rf linux-2.6.27; sync"
real	0m3.024s
user	0m0.040s
sys	0m0.750s

This jfs partition is located a bit further on the same disk,
so raw speed of it is a bit lower.  Yet the numbers are pretty
similar.  In any case, xfs with barriers is MUCH worse...

The disk is a 500Gig Hitachi HUA72105 one ("raid edition"),
on an AMD 780g/SB700 chipset in ahci mode.

/mjt
