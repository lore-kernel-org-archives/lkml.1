Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYKXSAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYKXSAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 13:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYKXSAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 13:00:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYKXSAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 13:00:39 -0500
Date: Mon, 24 Nov 2008 13:00:36 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Paul Mackerras <paulus@samba.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@ozlabs.org,
       Milton Miller <miltonm@bga.com>, Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/5] powerpc: ftrace, convert to new dynamic ftrace arch
 API
In-Reply-To: <18730.1723.708467.812600@drongo.ozlabs.ibm.com>
Message-ID: <alpine.DEB.1.10.0811241256370.32561@gandalf.stny.rr.com>
References: <20081120190948.057007623@goodmis.org> <20081120191149.285359258@goodmis.org> <18730.1723.708467.812600@drongo.ozlabs.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 24 Nov 2008, Paul Mackerras wrote:

> Steven Rostedt writes:
> 
> > Thanks to Paul Mackennas for pointing out the mistakes of my original
> 
> Mackerras

Heh, I have two reasons for that typo.

 1) I reference Paul McKenney a lot, and my fingers are programmed.
 2) I type with the dvorak layout, and the 'r' is just above the 'n'.
    qwerty 'o' == dvorak 'r'
    qwerty 'l' == dvorak 'n'

;-)

> 
> > +static int test_24bit_addr(unsigned long ip, unsigned long addr)
> > +{
> > +	long diff;
> > +
> > +	/*
> > +	 * Can we get to addr from ip in 24 bits?
> > +	 *  (26 really, since we mulitply by 4 for 4 byte alignment)
> > +	 */
> > +	diff = addr - ip;
> > +
> > +	/*
> > +	 * Return true if diff is less than 1 << 25
> > +	 *  and greater than -1 << 26.
> > +	 */
> > +	return (diff < (1 << 25)) && (diff > (-1 << 26));
> 
> I think this still isn't right, and the comment is one of those ones
> that is only useful to people who can't read C, as it's just a
> transliteration of the code.

Argh!!! That must be a misfold.  I fixed that code.  The final version 
ad the same shift for both.

> 
> The comment should say something like "Return true if diff can be
> represented as a 26-bit twos-complement binary number" and the second
> part of the test should be (diff >= (-1 << 25)).  However, since you
> define a test_offset() function in patch 4/5 that does the same test
> but using only one comparison instead of two, why don't you just say:
> 
> 	return !test_offset(diff);
> 
> (having first moved test_offset() before test_24bit_addr)?

OK, will fix. Thanks. Hmm, maybe I ment to do that, and miss the patch :-/

-- Steve

