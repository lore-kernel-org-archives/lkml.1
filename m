Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbYF0Rk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbYF0Rk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYF0RkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:40:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55957 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYF0RkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:40:15 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5327"; a="4285554"
Message-ID: <486525FE.1060509@qualcomm.com>
Date: Fri, 27 Jun 2008 10:40:14 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, oleg@tv-sign.ru, jarkao2@o2.pl
CC: linux-kernel@vger.kernel.org
Subject: workqueue flush_work() patches
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,
Oleg,

I'm not sure if you guys saw my last email on this. So I'll restart the 
thread.
If you guys are ok with the summary I provided below I can put all 
Oleg's patches into some git tree, test them on my boxes and resend to 
Andrew. I was also going to go over the users of flush_queued_work() and 
convert them to cancel_work_sync() and/or flush_work(). So I need to 
know if we want to go ahead with the flush_work() patches.
Please see summary below and let me know what you guys think.

Thanx
Max

----

Peter Zijlstra wrote:
 > Anyway, I think before we go further down this road, we'd better see
 > if anybody actually needs this. Not that theorizing about this problem
 > isn't fun,... but... :-)

Let me see if I can sum up current state of affairs. Looks like people 
are in general ok with Oleg's patches. Fancier stuff is much more 
complex and may not be needed.
Combining Oleg's patches with auditing current flush_scheduled_work() 
users and fixing them to use cancel_work_sync() (and in some cases 
flush_work()) gives us desired behaviour. Which is:
	1. minimizing flush overhead
	2. handling (actually avoiding) work queue thread starvation

Does that sound right ? Or did I miss something in the discussion ?

If that sounds right we should resend the patches to Andrew with formal 
ACKs because I do not seem them in mainline, linux-next or -mm.

Thanks
Max
