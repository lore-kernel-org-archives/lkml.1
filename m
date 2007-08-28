Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbXH1MLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbXH1MLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbXH1MLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 08:11:12 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45222 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbXH1MLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 08:11:12 -0400
Date: Tue, 28 Aug 2007 14:11:10 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Luka Napotnik <luka.napotnik@gmail.com>
cc: "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: division and cpu usage
In-Reply-To: <46D3FBDF.3080508@gmail.com>
Message-ID: <Pine.LNX.4.64.0708281410230.3018@fbirervta.pbzchgretzou.qr>
References: <46CE1BA2.8070200@gmail.com> <Pine.LNX.4.61.0708240731130.8096@chaos.analogic.com>
 <Pine.LNX.4.64.0708241442590.28540@fbirervta.pbzchgretzou.qr>
 <46D34B19.6050006@gmail.com> <Pine.LNX.4.64.0708280843030.11442@fbirervta.pbzchgretzou.qr>
 <46D3FBDF.3080508@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28 2007 12:41, Luka Napotnik wrote:
>
>How about this:
>===============================
>old_stime = task->stime;
>old_utime = task->utime
>old_j = jiffies;
>
>set_current_state(TASK_INTERRUPTIBLE);
>schedule_timeout(1 * HZ);
>
>new_stime = task->stime;
>new_utime = task->utime;
>new_j = jiffies;
>sum = ((new_stime - old_stime) + (new_utime - old_utime)) * 100 / (new_j
>- old_j)
>===============================
>
>I get how much time the task has spent in 1 sec in the scheduler and
>then get the percentage?

Looks sane to me. Though you have to try. And, like I said before, be aware of
dynticks, so you might want to use something else than jiffies. Not sure what
the function was called though.

	Jan
-- 
