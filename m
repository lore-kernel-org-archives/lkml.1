Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbXC0Fn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbXC0Fn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 01:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934003AbXC0Fn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 01:43:28 -0400
Received: from gw.goop.org ([64.81.55.164]:47234 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986AbXC0Fn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 01:43:27 -0400
Message-ID: <4608AF01.4060804@goop.org>
Date: Mon, 26 Mar 2007 22:43:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       clalance@redhat.com, mingo@redhat.com, davej@redhat.com,
       Thilo.Cestonaro.external@fujitsu-siemens.com
Subject: Re: [PATCH]: Fix bogus softlockup warning with sysrq-t
References: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com>
In-Reply-To: <20070315132247.11291.28827.sendpatchset@prarit.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava wrote:
> There are some situations when soft lockup warnings are expected in the
> kernel.  For example, when doing an alt-sysrq-t on a large number of processes,
> the dump to console can take a long time and the tasklist_lock is held over
> that period.  This results in a bogus soft lockup warning.
>   

Wouldn't it be better to just temporarily disable softlockups for the
duration?

> This patch reworks touch_softlockup_watchdog to touch ALL cpu's
> touch_timestamp.  It also introduces touch_cpu_softlockup_watchdog to touch
> a single cpu's touch_timestamp.

Doesn't this mean that if one CPU gets locked up, it will be undetected
so long as some other CPU is making progress?

I have another pair of softlockup patches in which I try to address:

    * ignoring time stolen by hypervisors
    * threads going to sleep tickless for long periods of time

I could easy add a "global disable" function, which would allow long
sysrq messages, and it would help Thilo with his long flash update freezes.

    J
