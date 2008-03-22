Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYCVFr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYCVFr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 01:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYCVFrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 01:47:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:49291 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752339AbYCVFrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 01:47:48 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19PC6RxFEBPx6AmB8Mojy1lFWKjXDZVkCRbuzL5ML
	9WqJ+9iGiHfQbP
Subject: Re: Scalability requirements for sysv ipc
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <47E3DD8C.4000904@colorfullife.com>
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>
	 <47E3B924.3000304@colorfullife.com>
	 <20080321141339.GB9618@linux.vnet.ibm.com>
	 <47E3DD8C.4000904@colorfullife.com>
Content-Type: text/plain
Date: Sat, 22 Mar 2008 06:43:28 +0100
Message-Id: <1206164608.3659.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-21 at 17:08 +0100, Manfred Spraul wrote: 
> Paul E. McKenney wrote:
> > I could give it a spin -- though I would need to be pointed to the
> > patch and the test.
> >
> >   
> I'd just compare a recent kernel with something older, pre Fri Oct 19 
> 11:53:44 2007
> 
> Then download ctxbench, run one instance on each core, bound with taskset.
> http://www.tmr.com/%7Epublic/source/
> (I don't juse ctxbench myself, if it doesn't work then I could post my 
> own app. It would be i386 only with RDTSCs inside)

(test gizmos are always welcome)

Results for Q6600 box don't look particularly wonderful.

taskset -c 3 ./ctx -s 

2.6.24.3
3766962 itterations in 9.999845 seconds = 376734/sec

2.6.22.18-cfs-v24.1
4375920 itterations in 10.006199 seconds = 437330/sec

for i in 0 1 2 3; do taskset -c $i ./ctx -s& done

2.6.22.18-cfs-v24.1
4355784 itterations in 10.005670 seconds = 435361/sec
4396033 itterations in 10.005686 seconds = 439384/sec
4390027 itterations in 10.006511 seconds = 438739/sec
4383906 itterations in 10.006834 seconds = 438128/sec

2.6.24.3
1269937 itterations in 9.999757 seconds = 127006/sec
1266723 itterations in 9.999663 seconds = 126685/sec
1267293 itterations in 9.999348 seconds = 126742/sec
1265793 itterations in 9.999766 seconds = 126592/sec

	-Mike

