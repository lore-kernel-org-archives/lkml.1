Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZK0Kdt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZK0Kdt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 05:33:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZK0Kdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 05:33:49 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53981 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbZK0Kds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 05:33:48 -0500
To: "Nikita V. Youshchenko" <yoush@cs.msu.su>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Boot cpu != cpu 0 ?
From: Andi Kleen <andi@firstfloor.org>
References: <200911271233.58269@zigzag.lvk.cs.msu.su>
Date: Fri, 27 Nov 2009 11:33:50 +0100
In-Reply-To: <200911271233.58269@zigzag.lvk.cs.msu.su> (Nikita V. Youshchenko's message of "Fri, 27 Nov 2009 12:33:58 +0300")
Message-ID: <873a405ka9.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nikita V. Youshchenko" <yoush@cs.msu.su> writes:

> How hard it could be to build a system on multi-core arm hardware, that has 
> linux SMP running in cores other than 0th ?
>
> Say, if bootloader starts kernel on hardware core 1, will kernel be able to 
> work (and use cores 1,2,3 on 4-core hardware) after some tweaking? 
> Or "boot cpu" concept is uncouplable from "hardware core 0" by 
> architecture? 
>
> I'm asking because there is a project with a strict requerement to have 
> core 0 reserved and not touched by linux, and I need to understand how 
> realistic it is.

You need to be clear what CPU 0 means. It could be "Linux CPU
number 0" That will be always there (it's hard coded), but that's
really only a numbering convention inside a kernel that essentially
says "nth booted CPU"

Then there's the APIC ID, which is the number the CPU hardware
knows about. There's a APIC ID == 0. Linux does not rely
on CPU #0 having APIC ID 0, at least not in principle
(this has regressed occasionally in the past)

The larger problem with sharing cores like this is the memory map --
e.g. you would need to coordinate which kernels owns which hardware
and which memory, which is not trivial without help. The usual way to
do this is to use a VM.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
