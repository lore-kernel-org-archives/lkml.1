Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZDKGAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZDKGAi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZDKGA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:00:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33643
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbZDKGAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:00:25 -0400
Date: Fri, 10 Apr 2009 23:00:16 -0700 (PDT)
Message-Id: <20090410.230016.176733137.davem@davemloft.net>
To: jengelh@medozas.de
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       laijs@cn.fujitsu.com, shemminger@vyatta.com, jeff.chua.linux@gmail.com,
       dada1@cosmosbay.com, kaber@trash.net, r000n@r000n.net,
       linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: iptables very slow after commit
 784544739a25c30637397ace5489eeb6e15d7d49
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LSU.2.00.0904110657410.26485@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.2.00.0904101828490.4583@localhost.localdomain>
	<20090411041533.GB6822@linux.vnet.ibm.com>
	<alpine.LSU.2.00.0904110657410.26485@fbirervta.pbzchgretzou.qr>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Engelhardt <jengelh@medozas.de>
Date: Sat, 11 Apr 2009 07:14:50 +0200 (CEST)

> The fact that `iptables -A` is called a hundred times means you are 
> doing 100 table replacements -- instead of one. And calling
> synchronize_net at least a 100 times.
> 
> "Wanna use iptables-restore?"

I want to derail this line of thinking as fast as possible.

This is not an acceptable response to this problem.  We made something
fundamentally slower by several orders of magnitude.

Therefore, saying "Don't insert your firewall rules like that." is not
a valid response for this regression.

We really have to fix it or revert.
