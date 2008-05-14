Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYENLnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYENLnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYENLnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:43:00 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:59510 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbYENLm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:42:59 -0400
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
From: Andi Kleen <andi@firstfloor.org>
References: <20080513204206.GA17781@damson.getinternet.no>
	<20080514065605.GB21369@elte.hu>
	<20080514090923.GC5607@alberich.amd.com>
Date: Wed, 14 May 2008 13:42:54 +0200
In-Reply-To: <20080514090923.GC5607@alberich.amd.com> (Andreas Herrmann's message of "Wed, 14 May 2008 11:09:23 +0200")
Message-ID: <87prrp6ri9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 14 May 2008 11:35:54.0631 (UTC) FILETIME=[AB845170:01C8B5B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann <andreas.herrmann3@amd.com> writes:
>
> It depends on the CPU. For AMD CPUs that support MWAIT this is wrong.
> Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings then
                                ^ not

> It might be best to switch off the mwait flag for these AMD CPU
> families like it was introduced with commit
> f039b754714a422959027cb18bb33760eb8153f0 (x86: Don't use MWAIT on AMD
> Family 10)

Then you have to special case everything again. We still need to 
work out if the P4 is even correct here or not, but if it's not
i would rather quirk the cpuid reporting on it.

-Andi
