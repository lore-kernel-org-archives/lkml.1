Return-Path: <linux-kernel-owner+w=401wt.eu-S1758247AbYDPSs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247AbYDPSs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYDPSsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:48:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55371 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbYDPSsi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:48:38 -0400
Date: Wed, 16 Apr 2008 20:48:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Johannes Weiner <hannes@saeurebad.de>, LKML <linux-kernel@vger.kernel.org>,
       Linux MM <linux-mm@kvack.org>, Andi Kleen <andi@firstfloor.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [RFC][patch 2/5] mm: Node-setup agnostic free_bootmem()
Message-ID: <20080416184816.GA4400@elte.hu>
References: <20080416113629.947746497@skyscraper.fehenstaub.lan> <20080416113719.092060936@skyscraper.fehenstaub.lan> <86802c440804161054h6f0cfc3dmde49006afb7889b2@mail.gmail.com> <86802c440804161144id4f2a68i37513ac0428c693@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440804161144id4f2a68i37513ac0428c693@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> >  Yes, it should work well with cross nodes case.
> >
> >  but please add boundary check on free_bootmem_node too.
> 
> also please note: it will have problem span nodes box.
> 
> for example: node 0: 0-2g, 4-6g, node1: 2-4g, 6-8g. and if ramdisk sit 
> creoss 2G boundary. you will only free the range before 2g.

yes. Such systems _will_ become more common - so the "this is rare" 
arguments are incorrect. bootmem has to be robust enough to deal with 
it.

	Ingo
