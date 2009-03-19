Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZCSHPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZCSHPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 03:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbZCSHPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 03:15:30 -0400
Received: from matrixpower.ru ([195.178.208.66]:54812 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbZCSHP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 03:15:29 -0400
Date: Thu, 19 Mar 2009 10:15:18 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Gregory Haskins <ghaskins@novell.com>
Cc: David Miller <davem@davemloft.net>, vernux@us.ibm.com, andi@firstfloor.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Patrick Mullaney <pmullaney@novell.com>
Subject: Re: High contention on the sk_buff_head.lock
Message-ID: <20090319071517.GA7389@ioremap.net>
References: <87prge1rhu.fsf@basil.nowhere.org> <20090318.140340.55290859.davem@davemloft.net> <49C16349.9030503@us.ibm.com> <20090318.143844.173112261.davem@davemloft.net> <49C16D7C.3080003@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C16D7C.3080003@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 05:54:04PM -0400, Gregory Haskins (ghaskins@novell.com) wrote:
> Note that -rt doesnt typically context-switch under contention anymore
> since we introduced adaptive-locks.  Also note that the contention
> against the lock is still contention, regardless of whether you have -rt
> or not.  Its just that the slow-path to handle the contended case for
> -rt is more expensive than mainline.  However, once you have the
> contention as stated, you have already lost.
> 
> We have observed the posters findings ourselves in both mainline and
> -rt.  I.e. That lock doesnt scale very well once you have more than a
> handful of cores.  It's certainly a great area to look at for improving
> the overall stack, IMO, as I believe there is quite a bit of headroom
> left to be recovered that is buried there.

Something tells me that you observer skb head lock contention because
you stressed the network and anything else on that machine slacked in
sleep. What if you will start IO stress, will __queue_lock contention
have the same magnitude order? Or having as many processes as skbs each
of which will race for the scheduler? Will run-queue lock show up in the
stats?

I believe the asnwer is yes for all the questions.
You stressed one subsystem and it showed up in the statistics.

-- 
	Evgeniy Polyakov
