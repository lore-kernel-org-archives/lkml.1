Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbYBULNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbYBULNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757714AbYBULNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:13:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:50984 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042AbYBULNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:13:11 -0500
Subject: Re: Make yield_task_fair more efficient
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47BD4D48.4080606@linux.vnet.ibm.com>
References: <20080221053321.GA26918@balbir.in.ibm.com>
	 <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
	 <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com>
	 <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com>
	 <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com>
	 <1203586980.6243.124.camel@lappy>  <47BD479F.6070901@linux.vnet.ibm.com>
	 <1203588090.6243.128.camel@lappy>  <47BD4D48.4080606@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 12:12:54 +0100
Message-Id: <1203592374.6243.138.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 15:37 +0530, Balbir Singh wrote:

> You use the empty pointer (missing right child), so why do we need a list. May
> be I am missing something.

A fully threaded tree also has back-pointer to traverse backwards
through the ordered elements.

That said, overloading the right child pointer might not be the best
thing for the linux kernel, as it will impact all the rb-tree lookups
which are open-coded and often performance critical (this is the reason
the colour isn't bit encoded in either of the child pointers either).

But if you only want a uni directional thread, I guess we can stick it
in the unsigned long we use for the node colour.

Still, perhaps it's worth it to grow rb_node to 4 words and do the fully
threaded thing as there are also a lot of rb_prev() users in the kernel.
Who knows..

Anyway, I agree that improving rb_next() is worth looking into for the
scheduler.


