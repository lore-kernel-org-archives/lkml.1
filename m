Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYA1BlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYA1BlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 20:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752202AbYA1BlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 20:41:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYA1BlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 20:41:06 -0500
Message-ID: <479D3287.1050604@redhat.com>
Date: Sun, 27 Jan 2008 20:40:23 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Regression] 2.6.24-git3: Major annoyance during suspend/hibernation
 on x86-64 (bisected)
References: <200801272229.48955.rjw@sisk.pl> <20080127215904.GB2686@elte.hu> <200801280226.22013.rjw@sisk.pl>
In-Reply-To: <200801280226.22013.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:

> No, this isn't the WARN_ON().
> 
>> this does have the feel of being scheduling related, but are you 
>> absolutely sure about the precise identity of the patch?
> 
> Actually, not quite.  That's why I have verified it and found that another
> patch is really responsible for the issue, namely:
> 
> commit 82a1fcb90287052aabfa235e7ffc693ea003fe69
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Jan 25 21:08:02 2008 +0100
> 
>     softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks

Are you getting a bunch of prints from the softlockup detector in dmesg?
I wonder if the detector can detect a long timeout caused by suspend and 
resume and if not is triggering false positives?

-- Steve

> 
> Reverting this commit (it reverts with some minor modifications) fixes the
> problem for me.
> 
