Return-Path: <linux-kernel-owner+w=401wt.eu-S1422709AbXBAQ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422709AbXBAQ44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 11:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161212AbXBAQ44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 11:56:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:58336 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161193AbXBAQ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 11:56:55 -0500
Subject: Re: [patch 0/9] x86_64: reliable TSC-based gettimeofday
From: john stultz <johnstul@us.ibm.com>
To: Jiri Bohac <jbohac@suse.cz>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Vojtech Pavlik <vojtech@suse.cz>, ssouhlal@freebsd.org,
       arjan@infradead.org, tglx@linutronix.de, zippel@linux-m68k.org,
       andrea@suse.de
In-Reply-To: <20070201145236.GA23394@dwarf.suse.cz>
References: <20070201095952.589234000@jet.suse.cz>
	 <200702011220.59484.ak@suse.de>  <20070201145236.GA23394@dwarf.suse.cz>
Content-Type: text/plain
Date: Thu, 01 Feb 2007 08:56:48 -0800
Message-Id: <1170349008.2558.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-01 at 15:52 +0100, Jiri Bohac wrote:
> On Thu, Feb 01, 2007 at 12:20:59PM +0100, Andi Kleen wrote:
>>
> > The big strategic problem is how to marry your patchkit to John Stultz's
> > clocksources work which is also competing for merge. Any thoughts on that? 
> 
> I'll look into that next week. Sorry, I wanted to do that a long time
> ago, but I spent weeks (over a month) fighting a nasty livelock
> in the code. (Morale: think twice before using a spinlock inside
>                       a {do .. while (read_seqretry(..))} loop)

The first step here shouldn't be too difficult. Just create a _read
function that uses your code to return monotonic TSC cycles (instead of
nanoseconds w/ gettimeofday).  Then just create a clocksource structure
for it.

The harder part will be the vsyscall, as you will need extra per cpu
data in the vsyscall read. I had some test code for this situation
awhile back, so if you get the first part functioning correctly (just a
clocksource w/o a vread pointer), I'll gladly help you get the vsyscall
bits working.

thanks
-john


