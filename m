Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbYHTOd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbYHTOd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 10:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYHTOdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 10:33:19 -0400
Received: from viefep31-int.chello.at ([62.179.121.49]:62069 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbYHTOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 10:33:18 -0400
Subject: Re: VolanoMark regression with 2.6.27-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: adobriyan@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Chris Friesen <cfriesen@nortel.com>
In-Reply-To: <20080820143209.GA32156@x200.localdomain>
References: <1912217169.25608.228.camel@ymzhang>
	 <1218180605.8625.64.camel@twins>
	 <20080811185008.GA29291@linux.vnet.ibm.com>
	 <1912726331.25608.235.camel@ymzhang>
	 <20080817115035.GA32223@linux.vnet.ibm.com>
	 <20080818052155.GA5063@linux.vnet.ibm.com>
	 <1219217089.8781.27.camel@ymzhang> <1219218089.10800.404.camel@twins>
	 <20080820105141.GA18226@elte.hu> <1219239137.8651.52.camel@twins>
	 <20080820143209.GA32156@x200.localdomain>
Content-Type: text/plain
Date: Wed, 20 Aug 2008 16:33:16 +0200
Message-Id: <1219242796.8651.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-20 at 18:32 +0400, adobriyan@gmail.com wrote:
> On Wed, Aug 20, 2008 at 03:32:17PM +0200, Peter Zijlstra wrote:
> > On Wed, 2008-08-20 at 12:51 +0200, Ingo Molnar wrote:
> > > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > And I must admit to having overlooked the effect on wake_affine..
> > > > 
> > > > Chris, could you see the effect of this on smp group fairness?
> > 
> > Just realized my brainfart..
> > 
> > ---
> > Subject: sched: load-balance bias fixes
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Wed Aug 20 15:28:51 CEST 2008
> > 
> > Yanmin spotted a regression with my patch that introduces LB_BIAS:
> > 
> >   commit 93b75217df39e6d75889cc6f8050343286aff4a5
> >   Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >   Date:   Fri Jun 27 13:41:33 2008 +0200
> > 
> > And I just spotted the brainfart - I should have replaced min/max with avg
> > instead of removing it completely.
> 
> > --- linux-2.6.orig/include/linux/kernel.h
> > +++ linux-2.6/include/linux/kernel.h
> > @@ -367,6 +367,12 @@ static inline char *pack_hex_byte(char *
> >  	(void) (&_max1 == &_max2);		\
> >  	_max1 > _max2 ? _max1 : _max2; })
> >  
> > +#define avg(x, y) ({				\
> > +	typeof(x) _avg1 = ((x)+1)/2;		\
> > +	typeof(x) _avg2 = ((y)+1)/2;		\
> 
> ITYM, typeof(y)

you thought right, I did mean that :-)

> > +	(void) (&_avg1 == &_avg2);		\
> > +	_avg1 + _avg2; })
> 

