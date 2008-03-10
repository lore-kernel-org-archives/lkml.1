Return-Path: <linux-kernel-owner+w=401wt.eu-S1753804AbYCJP4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbYCJP4Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 11:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYCJP4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 11:56:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33766 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751018AbYCJP4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 11:56:17 -0400
Date: Mon, 10 Mar 2008 08:55:41 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Ingo Molnar <mingo@elte.hu>
cc: Arjan van de Ven <arjan@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <20080309192514.GA16759@elte.hu>
Message-ID: <Pine.LNX.4.64.0803100855110.23575@schroedinger.engr.sgi.com>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
 <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu>
 <20080309121103.3f7019d5@laptopd505.fenrus.org> <20080309192514.GA16759@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Ingo Molnar wrote:

> > careful with this; the quicklists aren't JUST for speed they are also 
> > there to make sure a page we free that is a pagetable, is not reused 
> > until we have finished flushing the tlbs on all the cpus that saw it. 
> > This is a really hard correctness requirement, and while I can see 
> > that quicklists are probably not the best way to achieve this, we 
> > can't just throw away the behavior ;(
> 
> no, that's not true anymore - and the current quicklists code doesnt do 
> anything like that AFAICS. It used to be a lot more complex, but now 
> it's just a thin wrapper around the page allocator.

Sure it does that. It interacts with the TLB logic which is another bad 
thing as Linus has pointed out.


