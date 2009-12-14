Return-Path: <linux-kernel-owner+w=401wt.eu-S1757010AbZLNTpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010AbZLNTpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbZLNTpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:45:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbZLNTpI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:45:08 -0500
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
In-Reply-To: Oleg Nesterov's message of  Monday, 14 December 2009 18:03:27 +0100 <20091214170327.GA7666@redhat.com>
References: <20091124200220.GA5828@redhat.com>
	<1259697242.1697.1075.camel@laptop>
	<20091214002533.3052519@magilla.sf.frob.com>
	<20091214170327.GA7666@redhat.com>
Emacs: because extension languages should come with the editor built in.
Message-Id: <20091214194441.4D6BFE24E@magilla.sf.frob.com>
Date: Mon, 14 Dec 2009 11:44:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I think this is correct. It is fine to miss ->pending_attach == T,
> and in any case the new attacher can come right after the check, even
> if it was checked under utrace->lock.

Right.

> It is important that the tracee can't miss, say, UTRACE_REPORT request
> (as you already explained), and every time the tracee clears ->resume
> it calls splice_attaching().

Right.

> > In the stopped cases, there are lots of locks and barriers and things
> > after resuming.  (Oleg?)
> 
> Every time the tracee resumes after TASK_TRACED it uses utrace->lock
> to synchronize with utrace_control/etc, it must see any changes.

And TASK_STOPPED?

Please send me patches to add whatever comments would make all this clear
enough to Peter when reading the code.


Thanks,
Roland
