Return-Path: <linux-kernel-owner+w=401wt.eu-S1753772AbYE3TNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772AbYE3TNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 15:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYE3TNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 15:13:07 -0400
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:49494 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752009AbYE3TNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 15:13:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=FDBleijfBK2HLJz7YLaMiBt6r19m6zpaDO9r2JWQ7qwdie1lannGpFCVbITwaa+r;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Fri, 30 May 2008 15:12:50 -0400
From: Bill Fink <billfink@mindspring.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Cammarata <jimi@sngx.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
Message-Id: <20080530151250.b44a119a.billfink@mindspring.com>
In-Reply-To: <20080529154525.3916c7b5@core>
References: <482DA5B6.1020606@sngx.net>
	<482DB46A.8020103@cosmosbay.com>
	<482EF192.4070707@sngx.net>
	<482F5113.5090703@cosmosbay.com>
	<482F610D.2080108@sngx.net>
	<20080518003104.GK28241@solarflare.com>
	<482FBA09.80201@sngx.net>
	<483E0AAE.2020107@sngx.net>
	<20080528221118.63da4092.akpm@linux-foundation.org>
	<483EA2D1.8050603@sngx.net>
	<20080529154525.3916c7b5@core>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d3a9052958f5524f222330cbbec94c2b3350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Alan Cox wrote:

> > > Many of the kernel's accounting accumulators cannot be reset.  We
> > > handle that in userspace tools by using subtraction.
> > 
> > I don't think that should preclude the ability to reset these, unless it is
> > shown that it would break something very badly.
> 
> For one quite a few of the network cards keep the stats in hardware and
> don't neccessarily have a way to reset them. In other cases there is a
> mix of OS accumulated stats bulk updated by overflow events on the device
> itself.
> 
> Its a lot of complexity, and changes all over the places for the sake of
> a trivial userspace change. I would suggest you instead write a quick bit
> of perl or python that fetches the stats and then updates every second
> with the changes.

When diagnosing network problems, the ability to zero counters is
a major aid in diagnosis.  Writing scripts is not a general solution
since often several systems are involved and it's not simple to do
this via a script.  Saving stats output and running beforeafter on
a number of systems is a royal pain when troubleshooting.

I like the idea someone else had. where the clear stats actually did
a checkpoint of the stats, and then future get stats would return the
diff between the checkpointed and current values (perhaps there could
also be a mechanism to still get the absolute values if desired).

						-Bill
