Return-Path: <linux-kernel-owner+w=401wt.eu-S1765756AbYBZVcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765756AbYBZVcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762945AbYBZVck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:32:40 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:3172 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762499AbYBZVcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:32:39 -0500
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0802261253510.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	 <20080226115627.681dafb9.pj@sgi.com>
	 <alpine.DEB.1.00.0802261253510.10790@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 26 Feb 2008 16:32:46 -0500
Message-Id: <1204061567.5309.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 13:02 -0800, David Rientjes wrote:
> On Tue, 26 Feb 2008, Paul Jackson wrote:
> 
> > >         return do_mbind(start, len, mode, mode_flags, &nodes, flags);
> > 
> > The intermingling of 'flags', 'mode' and 'mode_flags' to refer to the
> > low bits, the high bits or all the bits of the flags field is handled
> > fairly carefully in your patch, but can still be a bit difficult to
> > keep track of which is which when reading.
> > 
> > I'll wager not many readers can immediately say what the 'mode',
> > 'mode_flags' and 'flags' refer to, in the above code snippet, for
> > example.
> > 
> > Do you have any suggestions on how to further improve the clarity of
> > this code?
> > 
> 
> This is a natural implementation detail to accomodate your insistance that 
> the mode and flags be passed as separate actuals throughout many of the 
> mm/mempolicy.c functions.

[:-(]

> 
> No reader is going to understand immediately what 'mode', 'mode_flags', 
> and 'flags' are if you only provide a single line of the code like that. 
> 
> It becomes rather obvious what they represent when you read the entire 
> sys_mbind() implementation, which is serving a syscall that provides its 
> own formal for passing flags.  The name 'mode_flags' is exactly what it 
> is: flags for the mempolicy mode.

Not to be confused with the MPOL_MF_* flags which are MemPOLicy Mbind
Flags passed via the flags parameter.  Nor the other MPOL_F_* flags
which are get_mempolicy() flags, also passed via the flags arg.

:-)

Later,
Lee
> 
> 		David

