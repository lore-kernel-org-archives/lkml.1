Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbYGBOoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbYGBOoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752840AbYGBOoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:44:16 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3137 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbYGBOoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:44:15 -0400
Date: Wed, 2 Jul 2008 15:44:06 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 4/4] capture pages freed during direct reclaim for allocation by the reclaimer
Message-ID: <20080702144406.GB16591@shadowen.org>
References: <1214935122-20828-1-git-send-email-apw@shadowen.org> <1214935122-20828-5-git-send-email-apw@shadowen.org> <20080702182909.D163.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702182909.D163.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2008 at 09:01:59PM +0900, KOSAKI Motohiro wrote:
> Hi Andy,
> 
> I feel this is interesting patch.
> 
> but I'm worry about it become increase OOM occur.
> What do you think?

We do hold onto some nearly free pages for a while longer but only in
direct reclaim, assuming kswapd is running its pages should not get
captured.  I am pushing our machines in test pretty hard, to the
unusable stage mostly without OOM'ing but that is still an artifical
test.  The amount of memory under capture is proportional to the size of
the allocations at the time of capture so one would hope this would only
be significant at very high orders.

> and, Why don't you make patch against -mm tree?

That is historical mostly as there was major churn in the same place when
I was originally making these patches, plus -mm was not bootable on any
of my test systems..  I am not sure if that is still true.  I will have
a look at a recent -mm and see if they will rebase and boot.

Thanks for looking.

-apw
