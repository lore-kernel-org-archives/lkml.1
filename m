Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbYCITZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbYCITZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 15:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508AbYCITZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 15:25:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37952 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbYCITZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 15:25:32 -0400
Date: Sun, 9 Mar 2008 20:25:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
Message-ID: <20080309192514.GA16759@elte.hu>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu> <20080309121103.3f7019d5@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080309121103.3f7019d5@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > > ouch! Could you try the patch below? How large is the quicklist 
> > > cache with this applied?
> > 
> > hm, Thomas pointed it out that this wont solve all the problems as 
> > quicklists have a built-in "preserve me" throttle (which is rather 
> > stupid).
> > 
> > the right solution is to get rid of quicklists altogether (Thomas 
> > expects to have patches for that later today).
> 
> careful with this; the quicklists aren't JUST for speed they are also 
> there to make sure a page we free that is a pagetable, is not reused 
> until we have finished flushing the tlbs on all the cpus that saw it. 
> This is a really hard correctness requirement, and while I can see 
> that quicklists are probably not the best way to achieve this, we 
> can't just throw away the behavior ;(

no, that's not true anymore - and the current quicklists code doesnt do 
anything like that AFAICS. It used to be a lot more complex, but now 
it's just a thin wrapper around the page allocator.

	Ingo
