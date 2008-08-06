Return-Path: <linux-kernel-owner+w=401wt.eu-S1030354AbYHFUXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030354AbYHFUXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757272AbYHFUXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:23:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7763 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210AbYHFUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:23:34 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5203529"
Message-ID: <489A0843.6050205@qualcomm.com>
Date: Wed, 06 Aug 2008 13:23:31 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
CC: mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitsu.com, jeff.chua.linux@gmail.com
Subject: Re: [PATCH] Resurect proper handling of maxcpus= kernel option
References: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com>
In-Reply-To: <1218052854-5020-1-git-send-email-Krasnyansky@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Max Krasnyansky <maxk@qualcomm.com>
> 
> For some reason we had redundant parsers registered for maxcpus=. 
> One in init/main.c and another in arch/x86/smpboot.c
> So I nuked the one in arch/x86.
> 
> Also 64-bit kernels used to handle maxcpus= as documented in
> Documentation/cpu-hotplug.txt. CPUs with 'id > maxcpus' are initialized
> but not booted. 32-bit version for some reason ignored them even though
> all the infrastructure for booting them later is there.
> 
> In the current mainline both 64 and 32 bit versions are broken. I'm
> too lazy to look through git history but I'm guessing it happened as
> part of the i386 and x86_64 unification.
> 
> This patch restores the correct behaviour. I've tested x86_64 version on
> 4- and 8- way Core2 and 2-way Opteron based machines. Various config
> combinations SMP, !SMP, CPU_HOTPLUG, !CPU_HOTPLUG.
> Booted with maxcpus=1 and maxcpus=4, etc. Everything is working as expected.
> 
> I cannot test 32-bit version (no 32-bit machines here).
> 
> Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
> Cc: lizf@cn.fujitsu.com
> Cc: jeff.chua.linux@gmail.com

I just realized that I managed to screw up my From: email address in 
git-send-email command line. Please reply to maxk@qualcomm.com.

Max
