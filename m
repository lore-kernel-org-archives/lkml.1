Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZJLKtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZJLKtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZJLKtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:49:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57760
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbZJLKtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:49:23 -0400
Date: Mon, 12 Oct 2009 03:49:19 -0700 (PDT)
Message-Id: <20091012.034919.98011643.davem@davemloft.net>
To: rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       skraw@ithnet.com, netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
       jesse.brandeburg@intel.com, peter.p.waskiewicz.jr@intel.com
Subject: Re: [Bug #14252] WARNING: at include/linux/skbuff.h:1382 w/ e1000
From: David Miller <davem@davemloft.net>
In-Reply-To: <L6tb-VyKHZK.A.9UD.zzl0KB@chimera>
References: <56acieJJ2fF.A.nEB.Hzl0KB@chimera>
	<L6tb-VyKHZK.A.9UD.zzl0KB@chimera>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rafael J. Wysocki" <rjw@sisk.pl>
Date: Mon, 12 Oct 2009 01:01:06 +0200 (CEST)

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14252
> Subject		: WARNING: at include/linux/skbuff.h:1382 w/ e1000
> Submitter	: Stephan von Krawczynski <skraw@ithnet.com>
> Date		: 2009-09-20 11:26 (22 days old)
> References	: http://marc.info/?l=linux-kernel&m=125344599006033&w=4

Hmmm... e1000 calls skb_trim() on both jumbo and non-jumbo ring
buffers which get recycled.

At least for the Jumbo case, that's illegal as you cannot call
skb_trim() on an SKB with paged data.

But this assertion is triggering for the non-jumbo ring where
only linear packets should be present as far as I can tell.

Some Intel folks need to take a look, CC:'d, and people need
to CC: their networking bug reports to netdev@vger.kernel.org
so that the proper folks see it.

Thanks.

