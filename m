Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZBRAkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZBRAkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZBRAkp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:40:45 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:40907 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbZBRAko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:40:44 -0500
Subject: Re: What can OpenVZ do?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, mpm@selenic.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, xemul@openvz.org,
       Nathan Lynch <nathanl@austin.ibm.com>
In-Reply-To: <20090218003217.GB25856@elte.hu>
References: <20090211141434.dfa1d079.akpm@linux-foundation.org>
	 <1234462282.30155.171.camel@nimitz> <1234467035.3243.538.camel@calx>
	 <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <20090213105302.GC4608@elte.hu> <1234817490.30155.287.camel@nimitz>
	 <20090217222319.GA10546@elte.hu> <1234909849.4816.9.camel@nimitz>
	 <20090218003217.GB25856@elte.hu>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 16:40:39 -0800
Message-Id: <1234917639.4816.12.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 01:32 +0100, Ingo Molnar wrote:
> > > Uncheckpointable should be a one-way flag anyway. We want this 
> > > to become usable, so uncheckpointable functionality should be as 
> > > painful as possible, to make sure it's getting fixed ...
> > 
> > Again, as these patches stand, we don't support checkpointing 
> > when non-simple files are opened.  Basically, if a 
> > open()/lseek() pair won't get you back where you were, we 
> > don't deal with them.
> > 
> > init does non-checkpointable things.  If the flag is a one-way 
> > trip, we'll never be able to checkpoint because we'll always 
> > inherit init's ! checkpointable flag.
> > 
> > To fix this, we could start working on making sure we can 
> > checkpoint init, but that's practically worthless.
> 
> i mean, it should be per process (per app) one-way flag of 
> course. If the app does something unsupported, it gets 
> non-checkpointable and that's it.

OK, we can definitely do that.  Do you think it is OK to run through a
set of checks at exec() time to check if the app currently has any
unsupported things going on?  If we don't directly inherit the parent's
status, then we need to have *some* time when we check it.

-- Dave

