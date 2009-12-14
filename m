Return-Path: <linux-kernel-owner+w=401wt.eu-S1756391AbZLNTnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391AbZLNTnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZLNTnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:43:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbZLNTnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:43:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/utrace
Cc: Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
In-Reply-To: Oleg Nesterov's message of  Monday, 14 December 2009 20:31:32 +0100 <20091214193132.GA14124@redhat.com>
References: <20091124200220.GA5828@redhat.com>
	<1259697242.1697.1075.camel@laptop>
	<20091214002533.3052519@magilla.sf.frob.com>
	<1260798696.4165.316.camel@twins>
	<20091214174127.GA9315@redhat.com>
	<20091214193132.GA14124@redhat.com>
X-Shopping-List: (1) Impotent defusers
   (2) Myopic tension helmets
   (3) Abrupt felonious competition colliders
   (4) Adamant exotic yies
   (5) Inconvenient aluminum
Message-Id: <20091214194250.15BE91DE@magilla.sf.frob.com>
Date: Mon, 14 Dec 2009 11:42:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/14, Oleg Nesterov wrote:
> >
> > IOW, we must ensure that if ever clear TIF_NOTIFY_RESUME we must not
> > miss ->pending_attach, correct? and for this case we have mb() after
> > clear_thread_flag(). Perhaps instead we should add mb__after_clear_bit()
> > into arch/ hooks, but this needs a lot of arch-dependent changes.

Since it's utrace/tracehook code that relies on the barrier I think it
makes sense to have it in tracehook_notify_resume() or utrace_resume().
The arch requirement is having done clear_thread_flag() beforehand, so the
arch-independent code can reasonably assume whatever semantics that is
guaranteed to have.

> Cough. And I always read this "rmb" as "mb". Even when I changed
> the comment to explain that we need a barrier between clear bit
> and read flags, I didn't notice it is in fact rmb...
> 
> I guess we need the trivial fix, Roland?

You're the barrier man, send me what changes it should get.


Thanks,
Roland
