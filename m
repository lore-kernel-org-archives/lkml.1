Return-Path: <linux-kernel-owner+w=401wt.eu-S1755948AbXKMK7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbXKMK7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbXKMK7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:59:17 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56285 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbXKMK7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:59:16 -0500
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on
	POWER
From: Peter Zijlstra <peterz@infradead.org>
To: benh@kernel.crashing.org
Cc: paulmck@linux.vnet.ibm.com, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com,
       antonb@us.ibm.com, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1194948338.6983.20.camel@twins>
References: <20071109181028.GA26800@linux.vnet.ibm.com>
	 <1194641524.21340.14.camel@pasglop>
	 <20071109220717.GJ8826@linux.vnet.ibm.com>
	 <1194753541.21340.26.camel@pasglop>
	 <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com>
	 <1194814125.6510.14.camel@pasglop>
	 <20071112191526.GC11113@linux.vnet.ibm.com>
	 <1194901925.18185.65.camel@pasglop>  <1194945032.6983.11.camel@twins>
	 <1194948338.6983.20.camel@twins>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 11:59:05 +0100
Message-Id: <1194951545.6983.26.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-13 at 11:05 +0100, Peter Zijlstra wrote:

> Anyway, it seems its the generic irq stuff that uses raw_spinlock_t and
> disables IRQs, so there isn't much we can do from the ARCH level I'm
> afraid :-(
> 
> Ingo, any sane ideas?

Ok benh came up with a workable idea, he just needs a night's sleep to
come up with the details :-)

The idea is to fill the radix tree from host->ops->map() (or
irq_create_mapping()) as that should still be preemptable, and then
convert all other uses to RCU lookups.



