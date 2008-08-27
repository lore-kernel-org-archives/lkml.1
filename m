Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbYH0WSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbYH0WSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYH0WS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:18:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47893
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753199AbYH0WS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:18:28 -0400
Date: Wed, 27 Aug 2008 15:18:24 -0700 (PDT)
Message-Id: <20080827.151824.14173512.davem@davemloft.net>
To: andi@firstfloor.org
Cc: rick.jones2@hp.com, johnpol@2ka.mipt.ru, dada1@cosmosbay.com,
       denys@visp.net.lb, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080827162735.GW26610@one.firstfloor.org>
References: <87vdxmr53f.fsf@basil.nowhere.org>
	<48B57BD3.5050206@hp.com>
	<20080827162735.GW26610@one.firstfloor.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Wed, 27 Aug 2008 18:27:35 +0200

> > Those banks really want to crank down on latency - to the point they 
> > start disabling interrupt coalescing.  I bet they'd toss anything out 
> > they could to shave another microsecond.
> 
> This change would actually likely lower their latency.

They want the timestamps, but they want it to match when the packet
arrived at their system as closely as is reasonably possible.

Socket based solutions don't do that, because we can be sleeping on
GFP_KERNEL memory or similar with the socket locked, and thus not
be able to set the timestamp until the task wakes up and processes
the backlog.
