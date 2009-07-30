Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZG3Tz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZG3Tz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 15:55:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752602AbZG3Tzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 15:55:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbZG3Tzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 15:55:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VxSXyIFan6jsylWc3PYliEFGu1AihKzPBn1LB8B8lym0E21mJxmmSXkEpPdgx4V5F
	tg5artsGd05RelXQcdc6g==
MIME-Version: 1.0
In-Reply-To: <20090730040803.GA20652@localhost>
References: <1786ab030907281211x6e432ba6ha6afe9de73f24e0c@mail.gmail.com>
	 <33307c790907281449k5e8d4f6cib2c93848f5ec2661@mail.gmail.com>
	 <33307c790907290015m1e6b5666x9c0014cdaf5ed08@mail.gmail.com>
	 <20090729114322.GA9335@localhost>
	 <33307c790907290711s320607b0i79c939104d4c2d61@mail.gmail.com>
	 <20090730010630.GA7326@localhost>
	 <33307c790907291812j40146a96tc2e9c5e097a33615@mail.gmail.com>
	 <20090730015754.GC7326@localhost>
	 <33307c790907291959r47b1bd3ap7cfa06fd5154aaad@mail.gmail.com>
	 <20090730040803.GA20652@localhost>
Date: Thu, 30 Jul 2009 12:55:44 -0700
Message-ID: <33307c790907301255j136e003dtac0e4ba2032e890e@mail.gmail.com>
Subject: Re: Bug in kernel 2.6.31, Slow wb_kupdate writeout
From: Martin Bligh <mbligh@google.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Michael Rubin <mrubin@google.com>,
       "sandeen@redhat.com" <sandeen@redhat.com>,
       Michael Davidson <md@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note that this is a simple fix that may have suboptimal write performance.
> Here is an old reasoning:
>
>        http://lkml.org/lkml/2009/3/28/235

The other thing I've been experimenting with is to disable the per-page
check in write_cache_pages, ie:

                        if (wbc->nonblocking && bdi_write_congested(bdi)) {
                                wb_stats_inc(WB_STATS_WCP_SECTION_CONG);
                                wbc->encountered_congestion = 1;
                                /* done = 1; */

This treats the congestion limits as soft, but encourages us to write
back in larger, more efficient chunks. If that's not going to scare
people unduly, I can submit that as well.
