Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbXCZOL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbXCZOL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 10:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXCZOL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 10:11:56 -0400
Received: from main.gmane.org ([80.91.229.2]:44516 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbXCZOLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 10:11:55 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
Date: Mon, 26 Mar 2007 16:11:22 +0200
Message-ID: <eu8kaa$stg$1@sea.gmane.org>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de> <200703261200.25587.marcus@better.se> <20070326123552.GB11288@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 67.152.216.81.static.g-va.siw.siwnet.net
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:

>> > Subject    : ThinkPad R60: suspend to disk broken
>> > References : http://lkml.org/lkml/2007/3/23/74

>> input, so I suspended to RAM again. This time the resume failed, it hung
>> after printing "Linux!" in yellow at the top of the screen.

> Yellow Linux! is my debugging trick.

Cute :-)

Here is my bisect log so far, with 98 revisions left. Note that all kernels have the XFS workqueue patch applied.

~$ git bisect log
git-bisect start
# bad: [6fb04ccf5c5e054c4107090bed6e866489f1089f] Linux 2.6.21-rc5
git-bisect bad 6fb04ccf5c5e054c4107090bed6e866489f1089f
# good: [c8f71b01a50597e298dc3214a2f2be7b8d31170c] Linux 2.6.21-rc1
git-bisect good c8f71b01a50597e298dc3214a2f2be7b8d31170c
# good: [ad5f1196792653dadf09c07a5fa917092b469c1c] ecryptfs: check xattr operation support fix
git-bisect good ad5f1196792653dadf09c07a5fa917092b469c1c
# good: [271368b69b9e8042063d6c713423e84503bbdaa0] Merge master.kernel.org:/pub/scm/linux/kernel/git/gregkh/driver-2.6
git-bisect good 271368b69b9e8042063d6c713423e84503bbdaa0
# bad: [f5b42c3324494ea3f9bf795e2a7e4d3cbb06c607] KVM: Fix guest sysenter on vmx
git-bisect bad f5b42c3324494ea3f9bf795e2a7e4d3cbb06c607

The bad kernels exhibit the hang on second resume from RAM.

The "good" ones all have the artifact with corrupted display. Moreover, they resume immediately from every suspend to RAM _after_ a suspend-to-disk, but not before it. This is when suspending with "echo mem > /sys/power/state".

> Try vga=0 ... text console seems to work for you.

Ok, will try.

Marcus


