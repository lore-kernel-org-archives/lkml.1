Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214Ab0CKV6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:58:42 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:38551 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab0CKV6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:58:40 -0500
Message-ID: <4B996766.5070509@hp.com>
Date: Thu, 11 Mar 2010 16:57:58 -0500
From: Brian Haley <brian.haley@hp.com>
Organization: Open Source and Linux Organization
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michael Chan <mchan@broadcom.com>
CC: David Miller <davem@davemloft.net>,
       "bonbons@linux-vserver.org" <bonbons@linux-vserver.org>,
       Benjamin Li <benli@broadcom.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BNX2: Kernel crashes with 2.6.31 and 2.6.31.9
References: <1268263973.9775.95.camel@nseg_linux_HP1.broadcom.com> <4B9850DC.9060703@hp.com> <1268329796.9775.125.camel@nseg_linux_HP1.broadcom.com> <20100311.100519.124285161.davem@davemloft.net> <1268332738.9775.133.camel@nseg_linux_HP1.broadcom.com> <4B994714.2040108@hp.com> <1268336848.9775.154.camel@nseg_linux_HP1.broadcom.com>
In-Reply-To: <1268336848.9775.154.camel@nseg_linux_HP1.broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Chan wrote:
> On Thu, 2010-03-11 at 11:40 -0800, Brian Haley wrote:
>> I can only reproduce this on one system out of many, so it's either a
>> race condition or bad hardware.  The only thing I can confirm at the
>> moment is that it's the code at the bottom of bnx2_set_coalesce()
>> that's causing it, I'm trying to go through all those codepaths now.
> 
> The NETDEV WATCHDOG is caused by stopping the TX queues with
> ->trans_start older than dev->watchdog_timeo which is set to 5 seconds
> in bnx2.  Please try this patch below to update the ->trans_start first
> before stopping the TX queues:

Well I'm an idiot.  Someone had cherry-picked commit 4529819c4 (that caused
the reset_task bnx2 crash), so it was bad code in bnx2_netif_stop()/start()
that's already been fixed upstream.  I'll merge our bnx2 code up to the
firmware commit and start testing again to see if we still see the watchdog
timeouts we've seen in the past.

Thanks for your help.

-Brian
