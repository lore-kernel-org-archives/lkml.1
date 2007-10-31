Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXJaVRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXJaVRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 17:17:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760236AbXJaVQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 17:16:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:50510 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760681AbXJaVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 17:16:35 -0400
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, antonb@us.ibm.com, rostedt@goodmis.org
In-Reply-To: <1193864075.9767.20.camel@Aeon>
References: <20071029185044.GA23413@linux.vnet.ibm.com>
	 <1193688468.9928.30.camel@pasglop>  <1193864075.9767.20.camel@Aeon>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 08:15:28 +1100
Message-Id: <1193865328.9928.141.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> So as Paul mentioned, spin_lock is now a mutex.  There is a new
> raw_spinlock however (simply change the way it is declared, calling
> conventions are the same) which is used in a very few areas where a
> traditional spin_lock is truly necessary.  This may or may not be one of
> those times, but I wanted to point it out.

Yeah, I figured that. My main worry has more to do with some fishy
assumptions the powerpc VM code does regarding what can and cannot
happen in those locked sections, among other things. I'll have to sit
and think about it for a little while to convince myself we are ok ...
or not. Plus we do keep track of various MM related things in per-CPU
data structures but it looks like Paul already spotted that.

Cheers,
Ben.


