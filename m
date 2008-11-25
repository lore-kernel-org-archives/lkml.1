Return-Path: <linux-kernel-owner+w=401wt.eu-S1752846AbYKYVDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbYKYVDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYKYVDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:03:36 -0500
Received: from buick.jordet.net ([193.91.240.190]:58521 "EHLO buick.jordet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbYKYVDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:03:35 -0500
Subject: Re: Extreme slowness with xfs [WAS: Re: Slowness with new pc]
From: Stian Jordet <liste@jordet.net>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
In-Reply-To: <492B5684.2080107@sandeen.net>
References: <1226760254.5089.11.camel@chevrolet>
	 <430c4fa50811180551r67d5d680tf1ffa493604ac4ea@mail.gmail.com>
	 <1227476908.32357.5.camel@chevrolet>
	 <alpine.DEB.1.10.0811231721350.22594@p34.internal.lan>
	 <1227485956.5145.10.camel@chevrolet>
	 <alpine.DEB.1.10.0811240448570.25866@p34.internal.lan>
	 <1227569808.5039.6.camel@chevrolet>  <492B5684.2080107@sandeen.net>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 22:03:30 +0100
Message-Id: <1227647010.7992.34.camel@chevrolet>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ma., 24.11.2008 kl. 19.36 -0600, skrev Eric Sandeen:
> I don't know if the storage you're on passes barriers or not, but xfs
> has barriers on by default, while ext3 does not.  ext3 will still
> likely
> win the "untar a kernel" race, but for a fairer test, make the barrier
> settings consistent between the two.


As I wrote earlier, the point wasn't to find the fastest fs. That's not
what I'm looking for. I just want xfs to perform at least as good on my
new workstation as it did on my six years old other workstation.

Which disabling barriers helped (notice the rm -rf with barriers...
nobarrier is almost 200 times faster, 10 times faster on the unpacking):

With barrier:

time bash -c 'tar xjf linux-2.6.27.7.tar.bz2 ; sync'

real 9m57.320s
user 0m16.253s
sys 0m2.692s

time bash -c 'rm -rf linux-2.6.27.7 ; sync'

real 4m46.130s
user 0m0.032s
sys 0m1.300s


No barrier: 

bash -c 'tar xjf linux-2.6.27.7.tar.bz2 ; sync'

real 0m57.028s
user 0m15.157s
sys 0m2.632s


time bash -c 'rm -rf linux-2.6.27.7 ; sync'

real 0m1.502s
user 0m0.032s
sys 0m1.436s

### Ext3

time bash -c 'tar xjf linux-2.6.27.7.tar.bz2 ; sync'

real 0m18.663s
user 0m14.693s
sys 0m2.828s


time bash -c 'rm -r linux-2.6.27.7 ; sync'
real 0m0.635s
user 0m0.028s
sys 0m0.564s


Altough I find it weird that both Michael and Justin does it faster on a
single disk than I do on my beefy hardware raid. But either way, finally
the system works ok, so I'm happy :) Ohh, wait. Justin is using just
the .tar... Well, that didn't really help that much here:

time bash -c 'tar xf linux-2.6.27.7.tar ; sync'

real	0m43.703s
user	0m0.256s
sys	0m3.312s


Thanks!

Regards,
Stian

