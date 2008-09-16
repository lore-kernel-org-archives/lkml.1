Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYIPORz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYIPORz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbYIPORc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:17:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50983 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbYIPORa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:17:30 -0400
Date: Tue, 16 Sep 2008 17:07:53 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: Mike Galbraith <efault@gmx.de>
cc: Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       kernel-testers@vger.kernel.org
Subject: Re: [Bug #11308] tbench regression on each kernel release from 2.6.22
 -&gt; 2.6.28
In-Reply-To: <1221568105.5020.17.camel@marge.simson.net>
Message-ID: <Pine.LNX.4.64.0809161700020.1034@wrl-59.cs.helsinki.fi>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>  <SpS7rta8n4.A.mr.ZesyIB@albercik>
  <48CAE7A0.8000004@linux-foundation.org>  <1221306287.5213.111.camel@marge.simson.net>
  <48CD1D25.9080301@linux-foundation.org>  <1221421907.4597.24.camel@marge.simson.net>
  <1221475440.4784.39.camel@marge.simson.net> <1221568105.5020.17.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008, Mike Galbraith wrote:

> On Mon, 2008-09-15 at 12:44 +0200, Mike Galbraith wrote:
> > On Sun, 2008-09-14 at 21:51 +0200, Mike Galbraith wrote:
> > 
> > Since 2.6.22.19-cfs-v24.1 and 2.6.23.17-cfs-v24.1 schedulers are
> > identical, and these are essentially identical with 2.6.24.7, what I
> > read from numbers below is that cfs in 2.6.23 was somewhat less than
> > wonderful for either netperf or tbench,  Something happened somewhere
> > other than the scheduler at 23->24 which cost us some performance, and
> > another something happened at 26->27.  I'll likely go looking again..
> > and likely regret it again ;-)
> 
> Bisecting 26->27 yet again turned up a repeatable downturn in netperf
> throughput.  There is no difference at this point with tbench. 
> 
> Bisect says first bad commit is 847106f, a security merge.  Post
> bisection sanity checkouts say...
> 
> v2.6.26-21-g2069f45
> 16384  87380  1        1       60.00    98435.13
> 16384  87380  1        1       60.01    99259.90
> 16384  87380  1        1       60.01    99325.61
> 16384  87380  1        1       60.00    99039.84
> 
> v2.6.26-343-g847106f
> 16384  87380  1        1       60.00    94764.59
> 16384  87380  1        1       60.00    94909.89
> 16384  87380  1        1       60.00    94858.63
> 16384  87380  1        1       60.00    94801.12
> 
> ...every time.  I knew I'd regret doing this.

I assume that c142bda458a gave a good results as well...

One additional sanity check could be to rebase security 6f0f0fd4963 on top 
of the c142bda458a and then see if bisection among those security commits 
on top yields to the the same result... Though I doubt it can change much 
because there was not that much relevant non-security things in the merge 
in question.

-- 
 i.

