Return-Path: <linux-kernel-owner+w=401wt.eu-S1759720AbZKFTtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720AbZKFTtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 14:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759685AbZKFTtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 14:49:07 -0500
Received: from smtp.ultrahosting.com ([74.213.175.253]:38239 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759562AbZKFTtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 14:49:07 -0500
Date: Fri, 6 Nov 2009 14:47:52 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@V090114053VZO-1
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Dave Jones <davej@redhat.com>,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: Re: [MM] Make mm counters per cpu instead of atomic V2
In-Reply-To: <ffef0f18fe9ae9948d0db7fb4b0a0341.squirrel@webmail-b.css.fujitsu.com>
Message-ID: <alpine.DEB.1.10.0911061446480.28386@V090114053VZO-1>
References: <alpine.DEB.1.10.0911041409020.7409@V090114053VZO-1>    <20091104234923.GA25306@redhat.com>    <alpine.DEB.1.10.0911051004360.25718@V090114053VZO-1>    <alpine.DEB.1.10.0911051035100.25718@V090114053VZO-1>    <20091106101106.8115e0f1.kamezawa.hiroyu@jp.fujitsu.com>
    <20091106122344.51118116.kamezawa.hiroyu@jp.fujitsu.com>    <alpine.DEB.1.10.0911061231580.5187@V090114053VZO-1>    <da621335371fccd6cfb3d8d7c0c2bf3a.squirrel@webmail-b.css.fujitsu.com>    <alpine.DEB.1.10.0911061409310.15636@V090114053VZO-1>
 <ffef0f18fe9ae9948d0db7fb4b0a0341.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 7 Nov 2009, KAMEZAWA Hiroyuki wrote:

> > If we just have one thread: Do we need atomic access at all?
> >
> Unfortunately, kswapd/vmscan touch this.

Right. And those can also occur from another processor that the process
never has run on before. Argh.

