Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYCDLGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYCDLGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 06:06:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755067AbYCDLGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 06:06:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544AbYCDLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 06:06:32 -0500
Subject: Re: [RFC/PATCH] cpuset: cpuset irq affinities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Jackson <pj@sgi.com>
Cc: maxk@qualcomm.com, mingo@elte.hu, tglx@linutronix.de, oleg@tv-sign.ru,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org, rientjes@google.com
In-Reply-To: <20080304013534.4e51ae48.pj@sgi.com>
References: <20080227222103.673194000@chello.nl>
	 <1204311351.6243.130.camel@lappy> <20080229190223.GA17820@elte.hu>
	 <47C87084.3090208@qualcomm.com> <1204318980.6243.133.camel@lappy>
	 <47C8771C.1070001@qualcomm.com> <1204545445.11412.6.camel@twins>
	 <20080303113621.1dfdda87.pj@sgi.com> <1204567052.6241.4.camel@lappy>
	 <20080303121033.c8c9651c.pj@sgi.com> <1204568316.8514.18.camel@twins>
	 <20080304013534.4e51ae48.pj@sgi.com>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 12:06:02 +0100
Message-Id: <1204628762.6241.46.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 01:35 -0600, Paul Jackson wrote:
> Peter wrote:
> > OK, understood, I'll try and come up with yet another scheme :-)
> 
> Would your per-cpuset 'irqs' file work if, unlike pids in the 'tasks' file,
> we allowed the same irq to be listed in multiple 'irqs' files?

I did think of that, but that seems rather awkward. For one, how would
you remove an irq from a cpuset?

Secondly, the beauty of the current solution is that we use
irq_desc->cs->cpus_allowed, if it were in multiple sets, we'd have to
iterate a list, and cpus_or() the bunch.



