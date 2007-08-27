Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbXH0B60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbXH0B60 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 21:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbXH0B6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 21:58:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42080
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbXH0B6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 21:58:17 -0400
Date: Sun, 26 Aug 2007 18:58:15 -0700 (PDT)
Message-Id: <20070826.185815.93042514.davem@davemloft.net>
To: jchapman@katalix.com
Cc: shemminger@linux-foundation.org, ossthema@de.ibm.com, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
Subject: Re: RFC: issues concerning the next NAPI interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <46D1D634.7060007@katalix.com>
References: <46CF127D.1090609@katalix.com>
	<20070824.144711.18301866.davem@davemloft.net>
	<46D1D634.7060007@katalix.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Chapman <jchapman@katalix.com>
Date: Sun, 26 Aug 2007 20:36:20 +0100

> David Miller wrote:
> > From: James Chapman <jchapman@katalix.com>
> > Date: Fri, 24 Aug 2007 18:16:45 +0100
> > 
> >> Does hardware interrupt mitigation really interact well with NAPI?
> > 
> > It interacts quite excellently.
> 
> If NAPI disables interrupts and keeps them disabled while there are more 
> packets arriving or more transmits being completed, why do hardware 
> interrupt mitigation / coalescing features of the network silicon help?

Because if your packet rate is low enough such that the cpu can
process the interrupt fast enough and thus only one packet gets
processed per NAPI poll, the cost of going into and out of NAPI mode
dominates the packet processing costs.
