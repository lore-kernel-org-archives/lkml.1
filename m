Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbYLaFJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbYLaFJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 00:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYLaFJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 00:09:21 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62676 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667AbYLaFJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 00:09:21 -0500
To: frederik.deweerdt@xprog.eu
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [2.6.28] NULL pointer dereference at get_stats()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200812302153.ECH86976.MFLOQFJHtSOOFV@I-love.SAKURA.ne.jp>
	<20081230155215.GA31531@gambetta>
	<200812310201.GJH43235.OFFLHFMStOJVOQ@I-love.SAKURA.ne.jp>
	<20081230213727.GA2001@gambetta>
In-Reply-To: <20081230213727.GA2001@gambetta>
Message-Id: <200812311409.EEC09369.VtOSLFJFMOOFQH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 31 Dec 2008 14:09:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Frederik Deweerdt wrote:
> Thanks for the thourough testing. I've reviewed the code, and the only
> think that looks weird to me is the case where smp_sanity_check() fails.
> The attached patch is an attempt to correct this, Tetsuo, could you
> test it?
That patch didn't solve.

Below are the results (with that patch applied) with more test cases.

Case | Result | # of virtual CPUs | # of CPUs recognized | Kernel command line
-----+--------+-------------------+----------------------+-----------------------------------------
(1)  | OK     | 2                 | 2                    | ro root=LABEL=/
(2)  | BUG    | 2                 | 1                    | ro root=LABEL=/ noapic nolapic
(3)  | BUG    | 2                 | 1                    | ro root=LABEL=/ noapic nolapic maxcpus=0
(4)  | BUG    | 2                 | 1                    | ro root=LABEL=/ noapic nolapic nosmp
(5)  | BUG    | 2                 | 1                    | ro root=LABEL=/ maxcpus=0
(6)  | BUG    | 2                 | 1                    | ro root=LABEL=/ nosmp
(7)  | OK     | 1                 | 1                    | ro root=LABEL=/
(8)  | OK     | 1                 | 1                    | ro root=LABEL=/ nolapic noapic
(9)  | OK     | 1                 | 1                    | ro root=LABEL=/ nolapic noapic maxcpus=0
(10) | OK     | 1                 | 1                    | ro root=LABEL=/ nolapic noapic nosmp
(11) | OK     | 2                 | 1                    | ro root=LABEL=/ maxcpus=1
(12) | OK     | 2                 | 2                    | ro root=LABEL=/ maxcpus=2
(13) | OK     | 2                 | 2                    | ro root=LABEL=/ maxcpus=4
(14) | BUG    | 2                 | 1                    | ro root=LABEL=/ noapic nolapic maxcpus=1
(15) | OK     | 2                 | 2                    | ro root=LABEL=/ noapic
(16) | BUG    | 2                 | 1                    | ro root=LABEL=/ noapic maxcpus=0
(17) | OK     | 2                 | 1                    | ro root=LABEL=/ noapic maxcpus=1
(18) | OK     | 2                 | 2                    | ro root=LABEL=/ noapic maxcpus=2
(19) | BUG    | 2                 | 1                    | ro root=LABEL=/ nolapic
(20) | BUG    | 2                 | 1                    | ro root=LABEL=/ nolapic maxcpus=0
(21) | BUG    | 2                 | 1                    | ro root=LABEL=/ nolapic maxcpus=1
(22) | BUG    | 2                 | 1                    | ro root=LABEL=/ nolapic maxcpus=2

"# of CPUs recognized" means "grep -c ^processor /proc/cpcinfo".

Well, (2) (19) (22) are obviously wrong. "nolapic" option implies "nosmp" option?

Regards.
