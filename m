Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZCWIiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZCWIiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZCWIiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:38:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48407
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752245AbZCWIiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:38:02 -0400
Date: Mon, 23 Mar 2009 01:37:49 -0700 (PDT)
Message-Id: <20090323.013749.122944803.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: jarkao2@gmail.com, vernux@us.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <49C74927.7020008@cosmosbay.com>
References: <20090320232943.GA3024@ami.dom.local>
	<49C74927.7020008@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Mon, 23 Mar 2009 09:32:39 +0100

> I dont understand, doesnt it defeat the ticket spinlock thing and fairness ?
> 
> Thread doing __qdisc_run() already owns the __QDISC_STATE_RUNNING bit.

Right.

Remember, the way this is designed is that if there is a busy
cpu taking packets out of the queue and putting them into the
device then other cpus will simply add to the queue and immediately
return.  This effectively keeps the queue running there processing
all the new work that other cpus are adding to the qdisc.

Those other cpus make these decisions by looking at that
__QDISC_STATE_RUNNING bit, which the queue runner grabs before
it does any work.
