Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbYD2Moi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbYD2Moi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYD2Mo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:44:29 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54661 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751181AbYD2Mo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:44:28 -0400
Date: Tue, 29 Apr 2008 07:44:26 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] disable softlockup detection at boottime
Message-ID: <20080429124426.GA20775@sgi.com>
References: <20080423201613.GA8546@sgi.com> <20080428165544.GE18210@elte.hu> <20080428185252.GC1167@sgi.com> <20080429123522.GK31271@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429123522.GK31271@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 02:35:22PM +0200, Ingo Molnar wrote:
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > I'm getting unaligned access errors trying to set it to anything, so 
> > it's not working for me currently (2.6.25):
> > 
> > It's tripping up on the address of 'one', which is an int that is not 
> > properly aligned for the unsigned long comparison in 
> > proc_doulongvec_minmax on my 64 bit machine.  Also, the value '0' is 
> > invalid for softlockup_thresh, correct?
> > 
> > I temporarily got around these issues with the following hack.
> 
> ah, sorry. But ... perhaps using threshold -1 would be the most 
> intuitive setting? (for 'infinite timeout' ==> softlockup detector 
> turned off) That way it all becomes configurable as part of the 
> threshold? No strong opinion though.
>

Having the ability to switch it off dynamically would be nice to have, but
will need a little work yet.  Any solution should also minimize the amount
of time spent in softlockup_tick.

Either '0' or '-1' seems OK to me, but if '-1' turns it off, do we allow
a value of '0'?.
