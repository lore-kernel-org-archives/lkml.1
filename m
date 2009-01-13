Return-Path: <linux-kernel-owner+w=401wt.eu-S1758231AbZAMXW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231AbZAMXW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:22:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbZAMXWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:22:17 -0500
Received: from styx.suse.cz ([82.119.242.94]:46797 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751900AbZAMXWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:22:17 -0500
Date: Wed, 14 Jan 2009 00:22:15 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
cc: Jeremy Fitzhardinge <jeremy@xensource.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove byte locks
In-Reply-To: <496D1F54.7070104@goop.org>
Message-ID: <alpine.LNX.1.10.0901140016520.5377@jikos.suse.cz>
References: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz> <20090112120743.GC24266@elte.hu> <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz> <20090112124401.GA31939@elte.hu> <496D1F54.7070104@goop.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, Jeremy Fitzhardinge wrote:

> My intention for that code was always that it be a simplest-possible 
> reference implementation for the spinlock pvops, and perhaps a basis for 
> a more specialized version (the Xen version is based on byte locks, for 
> example). The code is "dead" in the sense that it has no users, but it 
> also results in no generated code, and should be easy to maintain if the 
> spinlock API is changed (as it is a canary to show that the other 
> implementations will need changing too).  In particular, the "paravirt 
> spinlock" mechanism relies on all implementations using the same static 
> initializer, and I wanted there to be an obvious second implementation 
> so that if someone decided to change the ticketlock initializer, they'd 
> be forced to consider what happens with the bytelock initializer (and by 
> extension, any other implementation).

Why can't this just be somewhere in documentation? (possibly even with the 
byte locks code as a reference).

It is IMHO just totally confusing to have a spinlock implementation that 
is not used at all in the tree. It took me quite some time to go through 
this until I finally figured out that this code is actually never used. 
Currently, on first sight it might seem that byte locks are used whenever 
CONFIG_PARAVIRT is set, which is not true.

And apparently even Linus got confused by this, which also tells us 
something by itself, see [1].

[1] http://marc.info/?l=linux-kernel&m=123144211719754&w=2

-- 
Jiri Kosina
SUSE Labs
