Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954Ab0ASXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0ASXSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327Ab0ASXSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:18:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:51350 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab0ASXSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:18:53 -0500
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was:
 Re: [linux-pm] Memory allocations in .suspend became very unreliable)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <195c7a901001190104x164381f9v4a58d1fce70b17b6@mail.gmail.com>
References: <20100118110324.AE30.A69D9226@jp.fujitsu.com>
	 <201001182155.09727.rjw@sisk.pl>
	 <20100119101101.5F2E.A69D9226@jp.fujitsu.com>
	 <1263871194.724.520.camel@pasglop>
	 <195c7a901001190104x164381f9v4a58d1fce70b17b6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Jan 2010 10:17:51 +1100
Message-ID: <1263943071.724.540.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 10:04 +0100, Bastien ROUCARIES wrote:
> Instead of masking bit could we only check if incompatible flags are
> used during suspend, and warm deeply. Call stack will be therefore
> identified, and we could have some metrics about such problem.
> 
> It will be a debug option like lockdep but pretty low cost.

I still believe it would just be a giant can of worms to require every
call site of memory allocators to "know" whether suspend has been
started or not.... Along the same reasons why we added that stuff for
boot time allocs.

Cheers,
Ben.


