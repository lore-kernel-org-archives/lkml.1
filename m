Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbYEZSSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbYEZSSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 14:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYEZSSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 14:18:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48348 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbYEZSSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 14:18:36 -0400
Date: Mon, 26 May 2008 11:00:40 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       Michael Neuling <mikey@neuling.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
Message-ID: <20080526110040.5ddc4656@infradead.org>
In-Reply-To: <483AF25B.6090806@linux.vnet.ibm.com>
References: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
	<20080526085000.33787eac@infradead.org>
	<483AF25B.6090806@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 22:54:43 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Arjan,
> 
> 
> These problems exist anyway, irrespective of scaled accounting (I'd
> say that they are exceptions)
> 
> 1. The management tool does have access to the current frequency and
> maximum frequency, irrespective of scaled accounting. The decision
> could still be taken on the data that is already available and
> management tools can already use them 

it's sadly not as easy as you make it sound. From everything you wrote
you're making the assumption "if we're not at maximum frequency, we
have room to spare", which is very much not a correct assumption

> 2. With IDA, we'd have to
> document that APERF/MPERF can be greater than 100% if the system is
> overclocked.
> 
> Scaled accounting only intends to provide data already available.
> Interpretation is left to management tools and we'll document the
> corner cases that you just mentioned.

IDA is not overclocking, nor is it a corner case *at all*. It's the
common case in fact on more modern systems. Having the kernel present
"raw" data to applications that then have no idea how to really use it
to be honest isn't very attractive to me as idea: you're presenting a
very raw hardware interface that will keep changing over time in terms
of how to interpret the data... the kernel needs to abstract such hard
stuff from applications, not fully expose them to it. Especially since
these things *ARE* tricky and *WILL* change. Future x86 hardware will
have behavior that makes the "oh we'll document the corner cases"
extremely unpractical. Heck, even todays hardware (but arguably not yet
the server hardware) behaves like that. "Documenting the common case as
corner case" is not the right thing to do when introducing some new
behavior/interface. Sorry.
