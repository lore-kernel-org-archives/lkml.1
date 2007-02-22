Return-Path: <linux-kernel-owner+w=401wt.eu-S1751916AbXBVVdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbXBVVdJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:33:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbXBVVdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:33:09 -0500
Received: from kanga.kvack.org ([66.96.29.28]:54743 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbXBVVdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:33:07 -0500
Date: Thu, 22 Feb 2007 16:32:12 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Zach Brown <zach.brown@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222213212.GJ18976@kvack.org>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <A97A8AFD-3D1C-49EC-84DE-901D900244A0@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A97A8AFD-3D1C-49EC-84DE-901D900244A0@oracle.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 22, 2007 at 01:23:57PM -0800, Zach Brown wrote:
> As one of the poor suckers who has been fixing bugs in fs/aio.c and  
> fs/direct-io.c, I really want everyone to read Ingo's paragraph a few  
> times.  Have it printed on a t-shirt.

direct-io.c is evil.  Ridiculously.

> Amen.
> 
> As an experiment, I'm working on backing the sys_io_*() calls with  
> syslets.  It's looking very promising so far.

Great, I'd love to see the comparisons.

> >So all in one, i used to think that AIO state-machines have a long- 
> >term
> >place within the kernel, but with syslets i think i've proven myself
> >embarrasingly wrong =B-)
> 
> Welcome to the party :).

Well, there are always the 2.4 patches which are properly state drive and 
reasonably simple.  Retry was born out of a need to come up with a mechanism 
that had less impact on the core kernel code, and yes, it seems to be a 
failure and in dire need of replacement.

One other implementation to consider is actually using kernel threads 
compared to how syslets perform.  Direct IO for one always blocks, so 
there shouldn't be much of a performance difference compared to syslets, 
with the bonus that no arch specific code is needed.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
