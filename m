Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbZCSBzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbZCSBzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 21:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbZCSByz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 21:54:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48233
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751884AbZCSByy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 21:54:54 -0400
Date: Wed, 18 Mar 2009 18:54:41 -0700 (PDT)
Message-Id: <20090318.185441.138157931.davem@davemloft.net>
To: sven@thebigcorporation.com
Cc: ghaskins@novell.com, vernux@us.ibm.com, andi@firstfloor.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, pmullaney@novell.com
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1237427007.8204.55.camel@quadrophenia.thebigcorporation.com>
References: <1237425191.8204.41.camel@quadrophenia.thebigcorporation.com>
	<20090318.181713.62394874.davem@davemloft.net>
	<1237427007.8204.55.camel@quadrophenia.thebigcorporation.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
Date: Wed, 18 Mar 2009 18:43:27 -0700

> Do we have to rule-out per-CPU queues, that aggregate into a master
> queue in a batch-wise manner? 

That would violate the properties and characteristics expected by
the packet scheduler, wrt. to fair based fairness, rate limiting,
etc.

The only legal situation where we can parallelize to single device
is where only the most trivial packet scheduler is attached to
the device and the device is multiqueue, and that is exactly what
we do right now.
