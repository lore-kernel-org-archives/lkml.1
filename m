Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYITUBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYITUBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 16:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYITUBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 16:01:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50393
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751492AbYITUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 16:01:10 -0400
Date: Sat, 20 Sep 2008 13:00:58 -0700 (PDT)
Message-Id: <20080920.130058.90080260.davem@davemloft.net>
To: dwalker@mvista.com
Cc: arjan@infradead.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com, steffen.klassert@secunet.com
Subject: Re: [PATCH 0/2]: Remote softirq invocation infrastructure.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1221926529.1343.140.camel@localhost.localdomain>
References: <1221924561.1343.121.camel@localhost.localdomain>
	<20080920084512.58f7fb08@infradead.org>
	<1221926529.1343.140.camel@localhost.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walker <dwalker@mvista.com>
Date: Sat, 20 Sep 2008 09:02:09 -0700

> In the case of networking and block I would think a lot of the softirq
> activity is asserted from userspace.. Maybe the scheduler shouldn't be
> migrating these tasks, or could take this softirq activity into
> account ..

Absolutely wrong.

On a per-flow basis you want to push the work down as far
as possible down to individual cpus.  Why do you think the
hardware folks are devoting silicon to RX multiqueue facilities
that spread the RX work amongst available cpus using MSI-X?
