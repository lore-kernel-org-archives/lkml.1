Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbYCMTt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbYCMTt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbYCMTtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:49:18 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:37569 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbYCMTtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:49:17 -0400
Subject: Re: [patch 0/6] Guest page hinting version 6.
From: Zachary Amsden <zach@vmware.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       virtualization@lists.osdl.org, akpm@linux-foundation.org,
       nickpiggin@yahoo.com.au, frankeh@watson.ibm.com, rusty@rustcorp.com.au,
       andrea@qumranet.com, clameter@sgi.com, a.p.zijlstra@chello.nl,
       Keir Fraser <keir@xensource.com>, Ian Pratt <ian.pratt@xensource.com>
In-Reply-To: <Pine.LNX.4.64.0803131848080.800@blonde.site>
References: <20080312132132.520833247@de.ibm.com>
	 <Pine.LNX.4.64.0803131627450.17244@blonde.site> <47D9754B.1030509@goop.org>
	 <Pine.LNX.4.64.0803131848080.800@blonde.site>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 12:53:58 -0700
Message-Id: <1205438038.14987.1.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-03-13 at 18:55 +0000, Hugh Dickins wrote:
> On Thu, 13 Mar 2008, Jeremy Fitzhardinge wrote:
> > 
> > My other concern is just correctness over time on the Linux side.  We already
> > have enough trouble keeping things like the pte and page structure state in
> > sync, with resulting rare data-loss bugs.  Adding another layer which only
> > applies in specific environments raises the possibility for new bugs to be
> > un-noticed for a long time.  How can we structure the VM changes to make sure
> > that its robust in the face of maintenance?
> 
> Yes, that's the main concern, as whenever lots of subtlety is added.
> I wonder if there's any chance of a CONFIG_DEBUG mode, which could be
> run on anybody's x86 machine, without involving any virtualization, but
> in which the PAGE_STATEs become essential to the correct working of the mm.

How about a fake hypervisor, which is really just a random page evictor,
following the rules of CMM?

