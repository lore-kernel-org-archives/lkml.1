Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbZLNThi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbZLNThi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbZLNThh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:37:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbZLNThh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:37:37 -0500
Date: Mon, 14 Dec 2009 20:31:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Roland McGrath <roland@redhat.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, utrace-devel@redhat.com
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091214193132.GA14124@redhat.com>
References: <20091124200220.GA5828@redhat.com> <1259697242.1697.1075.camel@laptop> <20091214002533.3052519@magilla.sf.frob.com> <1260798696.4165.316.camel@twins> <20091214174127.GA9315@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091214174127.GA9315@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14, Oleg Nesterov wrote:
>
> IOW, we must ensure that if ever clear TIF_NOTIFY_RESUME we must not
> miss ->pending_attach, correct? and for this case we have mb() after
> clear_thread_flag(). Perhaps instead we should add mb__after_clear_bit()
> into arch/ hooks, but this needs a lot of arch-dependent changes.

Cough. And I always read this "rmb" as "mb". Even when I changed
the comment to explain that we need a barrier between clear bit
and read flags, I didn't notice it is in fact rmb...

I guess we need the trivial fix, Roland?

Oleg.

