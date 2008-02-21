Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbYBUKBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbYBUKBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 05:01:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYBUKBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 05:01:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52351 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781AbYBUKBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 05:01:46 -0500
Subject: Re: Make yield_task_fair more efficient
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <47BD479F.6070901@linux.vnet.ibm.com>
References: <20080221053321.GA26918@balbir.in.ibm.com>
	 <20080221060427.GA9159@elte.hu> <47BD1F75.5030506@linux.vnet.ibm.com>
	 <20080221070733.GA13694@elte.hu> <47BD2A99.3010608@linux.vnet.ibm.com>
	 <1203583439.6243.119.camel@lappy> <47BD3B56.3090404@linux.vnet.ibm.com>
	 <20080221090430.GA20055@elte.hu>  <47BD44FF.7070104@linux.vnet.ibm.com>
	 <1203586980.6243.124.camel@lappy>  <47BD479F.6070901@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 11:01:30 +0100
Message-Id: <1203588090.6243.128.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 15:12 +0530, Balbir Singh wrote:
> Peter Zijlstra wrote:
> > On Thu, 2008-02-21 at 15:01 +0530, Balbir Singh wrote:
> > 
> >> I have an alternate approach in mind (that I need to find time for),
> >> threaded-rbtrees. Walking the tree is really efficient, specially finding
> >> successor of a node.
> > 
> > Threading the rbtrees would be even more expensive, it would require a
> > list_head in each node and a full list operation for every tree
> > operation.
> > 
> 
> Peter, when I say threaded, I don't mean threaded as in tasks. Please see
> http://www.nist.gov/dads/HTML/threadedtree.html and
> http://datastructures.itgo.com/trees/tbt.htm

I'm quite aware of the meaning of threaded in the context of data
structures. They usually require additional list data and operations to
implement.

Look at how the latter link you provided grows the rb_node with one
pointer to provide a single linked list.

