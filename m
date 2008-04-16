Return-Path: <linux-kernel-owner+w=401wt.eu-S1762954AbYDPMrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762954AbYDPMrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 08:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757670AbYDPMrn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 08:47:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757434AbYDPMrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 08:47:42 -0400
Date: Wed, 16 Apr 2008 14:47:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: Does process need to have a kernel-side stack all the time?
Message-ID: <20080416124728.GA5050@elte.hu>
References: <200804141547.57719.vda.linux@googlemail.com> <87hce4uya8.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hce4uya8.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0021]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Denys Vlasenko <vda.linux@googlemail.com> writes:
> 
> > A lot of effort went into minimizing of stack usage.
> > If I understand it correctly, one of the reasons for this
> > was to be efficient and not have lots of pages
> > used for stacks when we have a lot of threads
> > (tens of thousands).
> 
> Actually the real reason the 4K stacks were introduced IIRC was that 
> the VM is not very good at allocation of order > 0 pages and that only 
> using order 0 and not order 1 in normal operation prevented some 
> stalls.

no, the primary motivation Arjan and me started working on 4K stacks and 
implemented it was what Denys mentioned: i had a testcase that ran 
50,000 threads before it ran out of memory - i wanted it to run 100,000 
threads. The improved order-0 behavior was just icing on the cake.

	Ingo
