Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbYBOKUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbYBOKUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbYBOKUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:20:05 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53650 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754337AbYBOKUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:20:02 -0500
Date: Fri, 15 Feb 2008 04:19:57 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080215041957.afe41262.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802141142160.17096@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
	<20080213020344.45c9d924.pj@sgi.com>
	<alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
	<20080213110426.15179378.pj@sgi.com>
	<alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com>
	<20080213142956.5ba52101.pj@sgi.com>
	<20080214042643.dff40c72.pj@sgi.com>
	<alpine.DEB.1.00.0802141142160.17096@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So basically the "relative" nodemask that is passed with 
> MPOL_F_RELATIVE_NODES is wrapped around the allowed nodes?
> 
> 	relative nodemask	mems_allowed	result
> 	1,3,5			4		4
> 	1,3,5			4-6		4-6
> 	1,3,5			4-8		4-5,7
> 	1,3,5			4-10		4,6,8
> 
> Is that correct?

By my calculation, all but the last line is correct.

We use zero-based numbering, so relative node '1' is the
'second' node, and the 'second' node in allowed nodes 4-10
is node 5, not 4.  Similarly for relative nodes '3' and '5'.

So that last line should be:

> 	1,3,5			4-10		5,7,9


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
