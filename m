Return-Path: <linux-kernel-owner+w=401wt.eu-S1754547AbYJCKik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbYJCKik (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYJCKic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:38:32 -0400
Received: from www.tglx.de ([62.245.132.106]:37441 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbYJCKib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:38:31 -0400
Date: Fri, 3 Oct 2008 12:37:28 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Hellwig <hch@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 2/5] genirq: add a quick check handler
In-Reply-To: <20081003082927.GA25683@infradead.org>
Message-ID: <alpine.LFD.1.10.0810031235220.5549@apollo.tec.linutronix.de>
References: <20081001223213.078984344@linutronix.de> <20081001223301.900862899@linutronix.de> <20081003082927.GA25683@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Christoph Hellwig wrote:

> On Wed, Oct 01, 2008 at 11:02:18PM -0000, Thomas Gleixner wrote:
> > Preparatory patch for threaded interrupt handlers.
> > 
> > Adds a quick check handler which is called before the real handler.
> > The quick check handler can decide whether the interrupt was originated
> > from the device or not. It can also declare the interrupt as handled
> > and subsequently avoid that the real handler is called.
> 
> I'd rather leave the handler as a handle which could return
> IRQ_NEEDS_HANDLING to get a separate thread_fn called.  This seems more
> intuitive and means less mess in the fastpath.

see patch 3/5 :)
 
> Maybe IRQ_NEEDS_HANDLING might better be named IRQ_THREADED os similar,
> but that's really getting into nitpicking..

The reason why I split this out is: when you start to convert your
driver, then you can split out the quick check handler first w/o
making the real handler threaded in the first place. Once you got that
right you can work on moving the real handler into a thread.

Thanks,

	tglx

