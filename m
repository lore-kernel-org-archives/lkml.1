Return-Path: <linux-kernel-owner+w=401wt.eu-S1757815AbYB2Kn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815AbYB2Kn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 05:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYB2Knv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 05:43:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35808 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbYB2Knv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 05:43:51 -0500
Subject: Re: Can Linux kernel handle unsynced TSC?
From: Peter Zijlstra <peterz@infradead.org>
To: Zhao Forrest <forrest.zhao@gmail.com>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
In-Reply-To: <ac8af0be0802290055m5ca1aa84yad6e38f6935f847@mail.gmail.com>
References: <ac8af0be0802290055m5ca1aa84yad6e38f6935f847@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 11:43:43 +0100
Message-Id: <1204281823.6243.78.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 16:55 +0800, Zhao Forrest wrote:
> Sorry for reposting it.
> 
> For example,
> 1 rdtsc() is invoked on CPU0
> 2 process is migrated to CPU1, and rdtsc() is invoked on CPU1
> 3 if TSC on CPU1 is slower than TSC on CPU0, can kernel guarantee
> that the second rdtsc() doesn't return a value smaller than the one
> returned by the first rdtsc()?

No, rdtsc() goes directly to the hardware. You need a (preferably cheap)
clock abstraction layer on top if you need this.

