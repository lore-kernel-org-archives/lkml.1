Return-Path: <linux-kernel-owner+w=401wt.eu-S1757102AbZDFUqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102AbZDFUqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 16:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZDFUqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 16:46:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58954 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZDFUqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 16:46:45 -0400
Subject: Re: [PATCH 5/6] perf_counter: add more context information
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <49DA6324.9080801@linux.vnet.ibm.com>
References: <20090402091158.291810516@chello.nl>
	 <20090402091319.493101305@chello.nl> <1238763023.798.27.camel@twins>
	 <49D654AB.4030207@linux.vnet.ibm.com>  <1239015668.798.4243.camel@twins>
	 <1239016035.798.4254.camel@twins>  <49DA4FA0.6090902@linux.vnet.ibm.com>
	 <1239044818.798.4775.camel@twins>  <49DA6324.9080801@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 22:46:39 +0200
Message-Id: <1239050799.4557.24.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-04-06 at 13:16 -0700, Corey Ashford wrote:

> >> One downside of this approach is that you if you specify "no header" 
> >> (currently not possible, but maybe later?), you will not be able to get 
> >> the level bits.
> > 
> > Would this be desirable? 

> I think it would.  For one use case I'm working on right now, simple 
> profiling, all I need are ip's.  If I could omit the header, that would 
> reduce the frequency of sigio's by a factor of three, and make it faster 
> to read up the ip's when the SIGIO's occur.

Self-profiling?

So you're interested in getting the smallest possible record size, that
would still be 2 u64, right? Otherwise you don't get the IP context that
started this.


