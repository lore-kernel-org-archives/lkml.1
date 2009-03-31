Return-Path: <linux-kernel-owner+w=401wt.eu-S1762291AbZCaGgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762291AbZCaGgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 02:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbZCaGgb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 02:36:31 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:33506 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbZCaGgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 02:36:31 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 01/15] perf_counter: unify and fix delayed counter
 wakeup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18897.44531.88862.844627@cargo.ozlabs.ibm.com>
References: <20090330170701.856843742@chello.nl>
	 <20090330171023.153932974@chello.nl>
	 <18897.44531.88862.844627@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 08:37:05 +0200
Message-Id: <1238481425.28248.1377.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-31 at 16:45 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > +void perf_counter_wakeup(struct perf_counter *counter)
> > +{
> > +	struct perf_mmap_data *data;
> > +
> > +	rcu_read_lock();
> > +	data = rcu_dereference(counter->data);
> > +	if (data) {
> > +		(void)atomic_xchg(&data->wakeup, POLL_IN);
> 
> Really just a nit, but how is this atomic_xchg any different from
> atomic_set(&data->wakeup, POLL_IN) aside from being slower?

Probably, I got my head in a twist, atomic_set() is simply an unlocked
assignment (although volatile), and I read the value using a locked
xchg().

I wasn't sure how these two would interact and so I chickened out :-)

