Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZFWRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZFWRqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZFWRqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:46:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53900 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbZFWRqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:46:11 -0400
Date: Tue, 23 Jun 2009 16:30:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 0/2] do_wait() wakeup optimization
Message-ID: <20090623143054.GA10069@redhat.com>
References: <20090622170432.GA4895@redhat.com> <93ad5f3f0906230955x357ff9evc334d4a5c6def20@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93ad5f3f0906230955x357ff9evc334d4a5c6def20@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Ratan Nalumasu wrote:
>
> Yes, it is something we really need. The specific case I have (hundreds of
> NTPL threads in a program, and each thread managing a child process), the
> CPU load is >99% with NTPL threads, near 0% with the patch
                                                   ^^^^^^^^^

Thanks. Did you test this patch, or do you mean the previous one?

> So, yes, the complication is worthwhile.

I am asking because I am not sure this change is enough, note the
"We can make child_wait_callback() more clever later" in the changelog.

__wake_up_parent() passes key = p, but we can pass more info and do
additional checks in child_wait_callback().

Oleg.

