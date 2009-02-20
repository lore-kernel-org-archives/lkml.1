Return-Path: <linux-kernel-owner+w=401wt.eu-S1758818AbZBTQAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758818AbZBTQAz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbZBTQAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:00:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbZBTQAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:00:46 -0500
Date: Fri, 20 Feb 2009 11:00:44 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 page fault checker
In-Reply-To: <20090220155036.GA3225@elte.hu>
Message-ID: <alpine.DEB.2.00.0902201100280.29217@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0902201012220.29217@gandalf.stny.rr.com> <20090220155036.GA3225@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Feb 2009, Ingo Molnar wrote:
> > -	return spurious_fault_check(error_code, pte);
> > +	ret = spurious_fault_check(error_code, pte);
> > +	if (!ret)
> > +		return 0;
> > +
> > +	/*
> > +	 * Make sure we have permissions in PMD
> > +	 * If not, then there's a bug in the page tables.
> > +	 */
> > +	ret = spurious_fault_check(error_code, (pte_t *) pmd);
> > +	WARN_ON(!ret);
> > +	return ret;
> >  }
> 
> i guess we could do this - but i'd rather have it as a 
> WARN_ONCE(), with some text - so that if it ever triggers it's 
> one surgical message.

OK, I'll make this update and rebase it.

-- Steve

