Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbZEWAbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbZEWAbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 20:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758279AbZEWAbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 20:31:01 -0400
Received: from mail.candelatech.com ([208.74.158.172]:35525 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbZEWAbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 20:31:00 -0400
Message-ID: <4A1743C5.9020803@candelatech.com>
Date: Fri, 22 May 2009 17:31:01 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Question on lockdep and sysrq - d
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm trying to debug an apparent deadlock in some code I'm
writing.

When I do a sysrq 'd', I get a nice dump of locks (I have lockdep enabled).

However, the output appears to show multiple processes holding the
same locks (rtnl_mutex, for example):

Showing all locks held in the system:
3 locks held by events/11/63:
  #0:  (events){--..}, at: [<ffffffff8104f71e>] run_workqueue+0xb1/0x216
  #1:  ((linkwatch_work).work){--..}, at: [<ffffffff8104f71e>] run_workqueue+0xb1/0x216
  #2:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
1 lock held by irqbalance/3360:
  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
1 lock held by hald/3605:
  #0:  (rtnl_mutex){--..}, at: [<ffffffff8125def1>] rtnl_lock+0x12/0x14
...

Is this merely showing processes that are blocked on trying to acquire these locks?

If so, is there any way to tell which processes have fully acquired locks v/s
just waiting to acquire them?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

