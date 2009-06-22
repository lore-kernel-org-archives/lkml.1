Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZFVIS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZFVIS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZFVISt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:18:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48513 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbZFVISs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:18:48 -0400
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: NMI watchdog + NOHZ question
From: Andi Kleen <andi@firstfloor.org>
References: <20090622.002722.53993293.davem@davemloft.net>
Date: Mon, 22 Jun 2009 10:18:50 +0200
In-Reply-To: <20090622.002722.53993293.davem@davemloft.net> (David Miller's message of "Mon, 22 Jun 2009 00:27:22 -0700 (PDT)")
Message-ID: <87bpog3clx.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
>
> Is there something fundamental that should be preventing this?

Unless that changed recently when I wasn't looking NOHZ should only
stop timers when the CPU is idle. So when a driver is doing
something and the interrupts are not disabled for too long the timers
should be ticking.

Then when you're idle interrupts should be never off, so the NMI
watchdog cannot fire. On x86 often the NMI watchdog is in fact
stopped on idle.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
