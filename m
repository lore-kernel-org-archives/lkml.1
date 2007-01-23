Return-Path: <linux-kernel-owner+w=401wt.eu-S932252AbXAWIdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252AbXAWIdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 03:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbXAWIdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 03:33:13 -0500
Received: from amsfep16-int.chello.nl ([62.179.120.11]:43809 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbXAWIdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 03:33:13 -0500
Subject: Re: Why active list and inactive list?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Rik van Riel <riel@redhat.com>, Balbir Singh <balbir@in.ibm.com>,
       Andrea Arcangeli <andrea@suse.de>,
       Niki Hammler <mailinglists@nobaq.net>, linux-kernel@vger.kernel.org,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com>
References: <45B55286.5060909@nobaq.net>
	 <20070123003939.GY13798@opteron.random> <45B56575.10807@in.ibm.com>
	 <Pine.LNX.4.64.0701221737510.30455@schroedinger.engr.sgi.com>
	 <45B569A4.3010006@redhat.com>
	 <Pine.LNX.4.64.0701221801420.30595@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Tue, 23 Jan 2007 09:29:52 +0100
Message-Id: <1169540992.6197.202.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-22 at 18:03 -0800, Christoph Lameter wrote:
> What happened to all those advanced page replacement endeavors? 

They are here:
http://programming.kicks-ass.net/kernel-patches/page-replace/2.6.19-pr1/

I should update to .20 soonish.

> What is the most promising of those?

I'm still torn between CLOCK-Pro and CART. 

CLOCK-Pro is still vulnerable to the cyclic scan use case, since at that
time all pages will have equal distance.

CART might be fixable (my CART-r approach) but I still have to study the
full ramifications of that (does it hurt other workloads?).

Both seems quite capable to distinguish between recency and frequency.
Neither use this horrid swappiness knob to distinguish between mapped
and unmapped pages.

The main problem I'm having is test cases, notably the lack thereof.
(and lack of time ofcourse ;-)

