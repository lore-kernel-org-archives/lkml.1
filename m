Return-Path: <linux-kernel-owner+w=401wt.eu-S932527AbXBNUD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbXBNUD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932529AbXBNUD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:03:58 -0500
Received: from kanga.kvack.org ([66.96.29.28]:50999 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbXBNUD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:03:57 -0500
Date: Wed, 14 Feb 2007 15:03:47 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 06/11] syslets: core, documentation
Message-ID: <20070214200347.GK32271@kvack.org>
References: <20060529212109.GA2058@elte.hu> <20070213142042.GG638@elte.hu> <20070214103655.GB4241@flint.arm.linux.org.uk> <20070214105039.GC6801@elte.hu> <20070214110419.GC4241@flint.arm.linux.org.uk> <Pine.LNX.4.64.0702140919200.7480@alien.or.mcafeemobile.com> <20070214180344.GI32271@kvack.org> <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141135390.7796@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 11:45:23AM -0800, Davide Libenzi wrote:
> Sort of, except that the whole thing can complete syncronously w/out 
> context switches. The real point of the whole fibrils/syslets solution is 
> that kind of optimization. The solution is as good as it is now, for 

Except that You Can't Do That (tm).  Try to predict beforehand if the code 
path being followed will touch the FPU or SSE state, and you can't.  There is 
no way to avoid the context switch overhead, as you have to preserve things 
so that whatever state is being returned to the user is as it was.  Unless 
you plan on resetting the state beforehand, but then you have to call into 
arch specific code that ends up with a comparable overhead to the context 
switch.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
