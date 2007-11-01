Return-Path: <linux-kernel-owner+w=401wt.eu-S1761952AbXKAPuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761952AbXKAPuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761319AbXKAPuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:50:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46446 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760961AbXKAPug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:50:36 -0400
Date: Thu, 1 Nov 2007 08:50:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, antonb@us.ibm.com, rostedt@goodmis.org
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
Message-ID: <20071101155028.GB14231@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071029185044.GA23413@linux.vnet.ibm.com> <1193688468.9928.30.camel@pasglop> <1193864075.9767.20.camel@Aeon> <1193865328.9928.141.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193865328.9928.141.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2007 at 08:15:28AM +1100, Benjamin Herrenschmidt wrote:
> 
> > So as Paul mentioned, spin_lock is now a mutex.  There is a new
> > raw_spinlock however (simply change the way it is declared, calling
> > conventions are the same) which is used in a very few areas where a
> > traditional spin_lock is truly necessary.  This may or may not be one of
> > those times, but I wanted to point it out.
> 
> Yeah, I figured that. My main worry has more to do with some fishy
> assumptions the powerpc VM code does regarding what can and cannot
> happen in those locked sections, among other things. I'll have to sit
> and think about it for a little while to convince myself we are ok ...
> or not. Plus we do keep track of various MM related things in per-CPU
> data structures but it looks like Paul already spotted that.

My concern would be that I failed to spot all of them.  ;-)

							Thanx, Paul
