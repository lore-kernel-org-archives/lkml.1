Return-Path: <linux-kernel-owner+w=401wt.eu-S1759940AbZCWUdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759940AbZCWUdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 16:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756313AbZCWUcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 16:32:55 -0400
Received: from viefep18-int.chello.at ([62.179.121.38]:55553 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbZCWUcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 16:32:55 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] degrade severity of lockdep printk
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090323202831.GC19208@bombadil.infradead.org>
References: <20090323201628.GB19208@bombadil.infradead.org>
	 <20090323202054.GA6395@elte.hu>
	 <20090323202831.GC19208@bombadil.infradead.org>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 21:32:35 +0100
Message-Id: <1237840355.24918.80.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 16:28 -0400, Kyle McMartin wrote:
> On Mon, Mar 23, 2009 at 09:20:54PM +0100, Ingo Molnar wrote:
> > 
> > Please report it in that case and get us to increase the limit.
> > 
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=489563
> 
> Although I don't really see how this can be particularly fixed, since
> any workload that allocates a struct with a lock, initializes, and then
> eventually frees it a whole bunch of times will run out of lock_lists
> won't it?

Not if the lock init site doesn't change. Modules are the big exception,
cycling modules will run you out of lockdep space..

