Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZHaNeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZHaNeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZHaNeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:34:03 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:34296 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZHaNeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:34:02 -0400
Message-ID: <4A9BD13E.4040501@gmail.com>
Date: Mon, 31 Aug 2009 15:33:50 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Wei Yongjun <yjwei@cn.fujitsu.com>,
       Netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] drop_monitor: fix trace_napi_poll_hit()
References: <4A9B6963.5090207@cn.fujitsu.com> <4A9B6E57.7090703@gmail.com> <20090831111245.GA2105@hmsreliant.think-freely.org>
In-Reply-To: <20090831111245.GA2105@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 31 Aug 2009 15:33:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman a écrit :
> I still see a large number of drivers that update dev->last_rx, although its
> not all as I look through the list, so something definately seems amiss.

Some drivers still update dev->last_rx for their own needs, not a core
network concern.

But a cleanup is certainly possible on few other drivers, about a dozen
if I count correctly.

> 
> If its not going to be consistently updated, why are still carrying that field
> in dev?  Are we just waiting on someone to do the janitorial work to remove it?
> If so, I can, and I'll fix up the drop monitor in the process, to use a private
> timestamp.

We have to keep dev->last_rx for bonding use, so please use a private
timestamp for drop monitor.

Thanks
