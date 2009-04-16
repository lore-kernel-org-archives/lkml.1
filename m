Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZDPOTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZDPOTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbZDPOT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:19:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34372 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbZDPOTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:19:25 -0400
Date: Thu, 16 Apr 2009 16:15:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Serge Hallyn <serue@us.ibm.com>,
       Steve Dickson <steved@redhat.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Daire Byrne <Daire.Byrne@framestore.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slow_work_execute() needs mb() before
	test_bit(SLOW_WORK_PENDING)
Message-ID: <20090416141510.GC6532@redhat.com>
References: <20090413220201.GA1368@redhat.com> <20090413201348.GA16661@redhat.com> <20090413201306.GA16653@redhat.com> <32305.1239659266@redhat.com> <14774.1239875022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14774.1239875022@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > But why do we need the barrier before clear_bit(SLOW_WORK_EXECUTING) ?
> > We do have one after test_and_clear_bit(SLOW_WORK_PENDING) above, and it
> > should be enough, no?
>
> No.  There lock is covering work->ops->execute(work) too, and that is after
> the clearance of SLOW_WORK_PENDING.  The UNLOCK-class barrier must go between
> execution and clearance of the execution lock bit.

Ah. Now I see.

It is still not clear to me whether we need a barrier after clear_bit_unlock.

Thanks David!

Oleg.

