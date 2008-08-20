Return-Path: <linux-kernel-owner+w=401wt.eu-S1758185AbYHTQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758185AbYHTQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbYHTQvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:51:47 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:52090 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758257AbYHTQvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:51:46 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, adobriyan@gmail.com,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
References: <1912217169.25608.228.camel@ymzhang>
	 <20080820143209.GA32156@x200.localdomain> <1219242796.8651.54.camel@twins>
	 <200808210110.37204.nickpiggin@yahoo.com.au>
	 <2c0942db0808200929r640b3a1cj33efc56cfd6db9b3@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 18:51:43 +0200
Message-Id: <1219251103.8651.61.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 09:29 -0700, Ray Lee wrote:
> On Wed, Aug 20, 2008 at 8:10 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Thursday 21 August 2008 00:33, Peter Zijlstra wrote:
> >> On Wed, 2008-08-20 at 18:32 +0400, adobriyan@gmail.com wrote:
> >> > On Wed, Aug 20, 2008 at 03:32:17PM +0200, Peter Zijlstra wrote:
> >
> >> > > +#define avg(x, y) ({                             \
> >> > > + typeof(x) _avg1 = ((x)+1)/2;            \
> >> > > + typeof(x) _avg2 = ((y)+1)/2;            \
> >> >
> >> > ITYM, typeof(y)
> >>
> >> you thought right, I did mean that :-)
> >>
> >> > > + (void) (&_avg1 == &_avg2);              \
> >> > > + _avg1 + _avg2; })
> >
> > I don't think this implementation of avg should go in kernel.h?
> >
> > It gives an average of 1 and 1 to be 2, 3 and 3 is 4, 1 and 3 is
> > 3 etc.
> >
> > Maybe it is reasonable for very high numbers that would overflow
> > if added first, but it doesn't seem reasonable for a generic
> > averaging function.
> 
> The usual way of averaging numbers that may be large is
> 
> #define avg(x, y) ({            \
>        typeof(x) _x = (x);      \
>        typeof(x) _y = (y);      \
>        (void) (&_x == &_y);     \
>        _x + (_y - _x)/2; })
> 
> ....which also works for small and negative numbers.

D'oh, why didn't I think of that..

