Return-Path: <linux-kernel-owner+w=401wt.eu-S933079AbZLNV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933079AbZLNV0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbZLNV0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:26:17 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:47395 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932662AbZLNV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:26:16 -0500
Message-ID: <4B26AD65.1020004@gmail.com>
Date: Mon, 14 Dec 2009 22:25:57 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: packet_sendmsg_spkt sleeping from invalid context
References: <20091214175211.GA5102@nowhere> <4B2690E7.4030303@gmail.com> <20091214205231.GB5037@nowhere>
In-Reply-To: <20091214205231.GB5037@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 14 Dec 2009 22:25:59 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/12/2009 21:52, Frederic Weisbecker a écrit :
> 
> I also wonder. Are you using PREEMPT_RCU ?

Not at all :)

But yes, this is illegal to do the memcpy_fromiovec() in rcu_read_lock() context.

> That may explain why you haven't seen this issue because
> might_sleep() doesn't see you are in a rcu read locked
> section as preemption is not disabled, but it is illegal to
> voluntarily sleep in such area (although it's fine with
> preempt rcu) as doing so with non-prempt RCU config would barf.
> 
> I'm trying a patch to handle that.

As you want, I also have a patch testing right now :)
