Return-Path: <linux-kernel-owner+w=401wt.eu-S1751952Ab0ATImN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0ATImN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 03:42:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750842Ab0ATImM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 03:42:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:33483 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab0ATImL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 03:42:11 -0500
Message-ID: <4B56C314.7000908@kernel.org>
Date: Wed, 20 Jan 2010 17:47:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 06/40] sched: add wakeup/sleep sched_notifiers and allow
 NULL notifier ops
References: <1263776272-382-1-git-send-email-tj@kernel.org>	 <1263776272-382-7-git-send-email-tj@kernel.org>	 <1263808633.4283.152.camel@laptop>  <4B5446A1.7070306@kernel.org>	 <1263818967.4283.459.camel@laptop> <4B55050B.5020600@kernel.org>	 <4B556D44.1060101@kernel.org> <1263891302.4283.641.camel@laptop>
In-Reply-To: <1263891302.4283.641.camel@laptop>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 08:41:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/19/2010 05:55 PM, Peter Zijlstra wrote:
> I think so, still doing a wakeup from a wakeup sounds like trouble in
> that it has the potential to a thundering herd, so I'd really rather
> you'd not do something like that.

cmwq is not gonna do that and if someone is gonna do that there of
course needs to be some sort of limiting.

I still feel a bit uneasy about calling out external callbacks before
scheduler internal state update is complete.  If you still think
moving it right below activate_task() would be better, I'll move it
and modify the comment above try_to_wake_up_local().  Please let me
know what you think.

Thanks.

-- 
tejun
