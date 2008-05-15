Return-Path: <linux-kernel-owner+w=401wt.eu-S1762659AbYEOQK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762659AbYEOQK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 12:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759023AbYEOQKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 12:10:50 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53658 "EHLO
	outbound3-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757909AbYEOQKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 12:10:49 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K0X3JW-01-FRE-01
Date: Thu, 15 May 2008 18:10:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       Valdis.Kletnieks@vt.edu, Matt Mackall <mpm@selenic.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [BISECTED] Lots of "rescheduling IPIs" in powertop
Message-ID: <20080515161010.GA9506@alberich.amd.com>
References: <20080513204206.GA17781@damson.getinternet.no> <20080514065605.GB21369@elte.hu> <20080514090923.GC5607@alberich.amd.com> <87prrp6ri9.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87prrp6ri9.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 May 2008 16:09:37.0158 (UTC) FILETIME=[1284D260:01C8B6A6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 01:42:54PM +0200, Andi Kleen wrote:
> Andreas Herrmann <andreas.herrmann3@amd.com> writes:
> >
> > It depends on the CPU. For AMD CPUs that support MWAIT this is wrong.
> > Family 0x10 and 0x11 CPUs will enter C1 on HLT. Powersavings then
>                                 ^ not

Not sure what you meant by your comment.
Maybe you should re-read the paragraph.

It's as simple as that:
If OS executes Halt the core enters C1.
The core exits C1 if an interrupt is received.

> > It might be best to switch off the mwait flag for these AMD CPU
> > families like it was introduced with commit
> > f039b754714a422959027cb18bb33760eb8153f0 (x86: Don't use MWAIT on AMD
> > Family 10)
> 
> Then you have to special case everything again. We still need to 
> work out if the P4 is even correct here or not, but if it's not
> i would rather quirk the cpuid reporting on it.

I just want to ensure that for AMD family 0x10 and 0x11 halt and not
mwait is executed when the core is idle.


Andreas


