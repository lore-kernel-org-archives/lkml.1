Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZEIHHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZEIHHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 03:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZEIHHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 03:07:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbZEIHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 03:07:01 -0400
Date: Sat, 9 May 2009 00:04:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ron <ron@debian.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for sched_clock() when using jiffies
Message-Id: <20090509000406.c2022a0b.akpm@linux-foundation.org>
In-Reply-To: <20090509040537.GA5417@homer.shelbyville.oz>
References: <20081126150645.GA28153@homer.shelbyville.oz>
	<1227712598.4454.199.camel@twins>
	<20081126153152.GB28153@homer.shelbyville.oz>
	<20081128144039.GG28138@elte.hu>
	<20090508132449.GV5417@homer.shelbyville.oz>
	<20090508200444.GA22132@homer.shelbyville.oz>
	<20090508160142.ad89944f.akpm@linux-foundation.org>
	<20090509004009.GZ5417@homer.shelbyville.oz>
	<20090508181559.4750800e.akpm@linux-foundation.org>
	<20090509040537.GA5417@homer.shelbyville.oz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 May 2009 13:35:37 +0930 Ron <ron@debian.org> wrote:

>  All 'real'
> sched_clock implementations (empirically) count from 0, except this
> default one.

Well you live and learn.

Yup, we should make the toy sched_clock() match the fancy ones.


otoh, sched_clock() should do the INTITAL_JIFFIES offsetting as well,
because there are probably callers of sched_clock() who are buggy in
the presence of sched_clock()-return-value wraparound.

otooh, sched_clock() wraparound takes nearly 500 years so we can
afford to wait until linux-2.7.x to fix this.


I'll go off and find your original patch.  This was all a difficult way of
writing the changelog ;)
