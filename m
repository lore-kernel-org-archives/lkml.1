Return-Path: <linux-kernel-owner+w=401wt.eu-S1759340AbZBEKOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759340AbZBEKOn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 05:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbZBEKOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 05:14:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42391
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755165AbZBEKOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 05:14:33 -0500
Date: Thu, 05 Feb 2009 02:14:29 -0800 (PST)
Message-Id: <20090205.021429.170975463.davem@davemloft.net>
To: mel@csn.ul.ie
Cc: kamezawa.hiroyu@jp.fujitsu.com, heiko.carstens@de.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: HOLES_IN_ZONE...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090205101023.GD26878@csn.ul.ie>
References: <20090204.222651.26527737.davem@davemloft.net>
	<20090205101023.GD26878@csn.ul.ie>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mel Gorman <mel@csn.ul.ie>
Date: Thu, 5 Feb 2009 10:10:23 +0000

> On Wed, Feb 04, 2009 at 10:26:51PM -0800, David Miller wrote:
> > As a suggestion, it would have been a lot more pleasant if the code
> > validated this requirement (in the !HOLES_IN_ZONE case) at boot time
> > instead of after 2 hours of stress testing :-(
> > 
> 
> Nice maybe, but we'd take a hit on pfn_valid_within() which goes from
> being compiled-away on architectures that don't need it to being
> a read of a shared cacheline and a branch.

I said at boot time Mel, not in the fast paths.  Meaning, we'd
check it after all the available ranges get registered and
tossed into the free page lists.

Anyways, it appears we have a fix already, read the rest of
the thread.
