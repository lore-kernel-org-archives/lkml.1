Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZBZL2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZBZL2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 06:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbZBZL2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 06:28:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZBZL2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 06:28:20 -0500
Subject: Re: [PATCH] cpuacct: add a branch prediction
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
References: <49A6475F.4000502@cn.fujitsu.com>
	 <20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A6501B.7040604@cn.fujitsu.com>
	 <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
	 <49A65455.4030204@cn.fujitsu.com>
	 <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com>
	 <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com>
	 <1235645076.4645.4781.camel@laptop>
	 <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Feb 2009 12:28:02 +0100
Message-Id: <1235647682.4948.15.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 20:17 +0900, KAMEZAWA Hiroyuki wrote:
> Peter Zijlstra さんは書きました：
> > On Thu, 2009-02-26 at 19:28 +0900, KAMEZAWA Hiroyuki wrote:
> >
> >> Taking hierarchy mutex while reading will make read-side stable.
> >
> > We're talking about scheduling here, taking a mutex to stop scheduling
> > won't work, nor will it be acceptible to use anything that will.
> >
> No mutex is necessary, anyway.
> hierarchy-walker function completely works well under rcu read lock,
> if small jitter is allowed.

Right, should be doable -- and looking at the code, we have this
horrible 32 bit exception in there that locks the rq in order to read
the 64bit value.

Would be grand to get rid of that,. how bad would it be for userspace to
get the occasionally fubarred value?

But aside from that, the cpu controller itself is also summing directly
up the hierarchy, so cpuacct doing the same doesn't seem odd.

