Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbXKRNY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbXKRNY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 08:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbXKRNYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 08:24:49 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbXKRNYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 08:24:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
Date: Sun, 18 Nov 2007 14:42:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org> <4740332A.80002@gmail.com> <474038C9.3040002@gmail.com>
In-Reply-To: <474038C9.3040002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711181442.09917.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 of November 2007, Jiri Slaby wrote:
> On 11/18/2007 01:42 PM, Jiri Slaby wrote:
> > See shot of prints here:
> > http://www.fi.muni.cz/~xslaby/sklad/susp_hang1.png
> 
> BTW output from that tree minus the patch:

Hm, it looks like one of the CPU hotplug notifiers is doing something wrong.

Can you try to see what happens (with the patch applied) if
thermal_throttle_cpu_callback() is not registered?

> _cpu_down: s
> _cpu_down: t
> CPU 1 is now offline
> SMP alternatives: switching to UP code
> _cpu_down: u
> notifier_call_chain: c FFFFFFFF80232370 1
> notifier_call_chain: c FFFFFFFF8026EF10 1
> notifier_call_chain: c FFFFFFFF8024B8F0 1
> notifier_call_chain: c FFFFFFFF802419E0 1
> notifier_call_chain: c FFFFFFFF80255B50 1
> notifier_call_chain: c FFFFFFFF80250C40 1
> notifier_call_chain: c FFFFFFFF8028E8F0 1
> notifier_call_chain: c FFFFFFFF802B59C0 1
> notifier_call_chain: c FFFFFFFF80323460 1
> notifier_call_chain: c FFFFFFFF80270990 0
> notifier_call_chain: c FFFFFFFF8023D5D0 1
> notifier_call_chain: c FFFFFFFF80266090 1
> notifier_call_chain: c FFFFFFFF802320A0 1
> notifier_call_chain: c FFFFFFFF80249DA0 1
> notifier_call_chain: c FFFFFFFF80318440 1
> notifier_call_chain: c FFFFFFFF8047BE80 1
> notifier_call_chain: c FFFFFFFF80212F40 0
> notifier_call_chain: c FFFFFFFF80216350 1
> notifier_call_chain: c FFFFFFFF80217220 1
> notifier_call_chain: c FFFFFFFF80218120 1
> _cpu_down: v
> _cpu_down: w
> _cpu_down: x
> _cpu_down: y
> _cpu_down: z
> disable_nonboot_cpus: 3 0
