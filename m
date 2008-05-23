Return-Path: <linux-kernel-owner+w=401wt.eu-S1760030AbYEWXVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760030AbYEWXVH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752647AbYEWXUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:20:54 -0400
Received: from westnet.com ([216.187.52.2]:58775 "EHLO westnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbYEWXUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:20:53 -0400
Date: Fri, 23 May 2008 19:18:40 -0400 (EDT)
From: Greg Smith <gsmith@gregsmith.com>
X-X-Sender: gsmith@westnet.com
To: Mike Galbraith <efault@gmx.de>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: PostgreSQL pgbench performance regression in 2.6.23+
In-Reply-To: <1211537717.5851.22.camel@marge.simson.net>
Message-ID: <Pine.GSO.4.64.0805231907150.25273@westnet.com>
References: <1211440207.5733.8.camel@marge.simson.net> 
 <20080522082814.GA4499@linux.vnet.ibm.com>  <1211447105.4823.7.camel@marge.simson.net>
  <1211452465.7606.8.camel@marge.simson.net>  <1211455553.4381.9.camel@marge.simson.net>
  <1211456659.29104.20.camel@twins>  <1211458176.5693.6.camel@marge.simson.net>
  <1211459081.29104.40.camel@twins>  <Pine.GSO.4.64.0805230232190.28654@westnet.com>
  <1211536814.5851.18.camel@marge.simson.net>  <20080523101000.GA13964@elte.hu>
 <1211537717.5851.22.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 May 2008, Mike Galbraith wrote:

> It was running SCHED_BATCH, features=0...it needed features=0 as well to 
> achieve O(1) batch performance.

I figured out how to run pgbench with chrt in order to get SCHED_BATCH 
behavior, but I don't understand what you mean by features=0 here.  Since 
I didn't see the same magnitude of different just using batch that seems 
important, where does that get set at?

I'm also curious what hardware your results are coming from, to fit them 
into my larger pgbench results context space.

Got my 4-core system back on-line again today (found some bad RAM) and 
wanted to try another round of tests on that.  Looks like you've defined 5 
test sets I should replicate:

2.6.22
2.6.22, batch
2.6.26.git
2.6.26.git, batch
2.6.26.git, batch + se.load.weight patch

Should I still be trying Peter's se.waker patch as well in this mix 
somewhere?

--
* Greg Smith gsmith@gregsmith.com http://www.gregsmith.com Baltimore, MD
