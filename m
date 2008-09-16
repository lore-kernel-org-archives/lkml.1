Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYIPM2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYIPM2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 08:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIPM2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 08:28:36 -0400
Received: from mail.gmx.net ([213.165.64.20]:33345 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750965AbYIPM2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 08:28:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX188pWIYxNE8ZcjolutgStnPGxVGgmzlVucWs8NOTX
	s+9NuRq0aalUNc
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1221475440.4784.39.camel@marge.simson.net>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	 <SpS7rta8n4.A.mr.ZesyIB@albercik>  <48CAE7A0.8000004@linux-foundation.org>
	 <1221306287.5213.111.camel@marge.simson.net>
	 <48CD1D25.9080301@linux-foundation.org>
	 <1221421907.4597.24.camel@marge.simson.net>
	 <1221475440.4784.39.camel@marge.simson.net>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 14:28:25 +0200
Message-Id: <1221568105.5020.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-15 at 12:44 +0200, Mike Galbraith wrote:
> On Sun, 2008-09-14 at 21:51 +0200, Mike Galbraith wrote:
> > On Sun, 2008-09-14 at 09:18 -0500, Christoph Lameter wrote:
> > > Mike Galbraith wrote:
> > > > Numbers from my Q6600 Aldi supermarket box (hm, your box is from different shelf)
> > > >   
> > > My box is an 8p with recent quad core processors. 8G, 32bit Linux.
> > 
> > Don't hold your breath, but after putting my network config of a very
> > severe diet, I'm starting to see something resembling sensible results.
> 
> Turns off all netfilter options except tables, etc.
> 
> Since 2.6.22.19-cfs-v24.1 and 2.6.23.17-cfs-v24.1 schedulers are
> identical, and these are essentially identical with 2.6.24.7, what I
> read from numbers below is that cfs in 2.6.23 was somewhat less than
> wonderful for either netperf or tbench,  Something happened somewhere
> other than the scheduler at 23->24 which cost us some performance, and
> another something happened at 26->27.  I'll likely go looking again..
> and likely regret it again ;-)

Bisecting 26->27 yet again turned up a repeatable downturn in netperf
throughput.  There is no difference at this point with tbench. 

Bisect says first bad commit is 847106f, a security merge.  Post
bisection sanity checkouts say...

v2.6.26-21-g2069f45
16384  87380  1        1       60.00    98435.13
16384  87380  1        1       60.01    99259.90
16384  87380  1        1       60.01    99325.61
16384  87380  1        1       60.00    99039.84

v2.6.26-343-g847106f
16384  87380  1        1       60.00    94764.59
16384  87380  1        1       60.00    94909.89
16384  87380  1        1       60.00    94858.63
16384  87380  1        1       60.00    94801.12

...every time.  I knew I'd regret doing this.

	-Mike

