Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbYGXO4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbYGXO4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 10:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760228AbYGXOzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 10:55:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:33795 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760221AbYGXOzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 10:55:38 -0400
Message-ID: <488897E4.8070806@windriver.com>
Date: Thu, 24 Jul 2008 09:55:32 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Francis Moreau <francis.moro@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: KGDB fails to pass selft tests on x86-64 (v2.6.26)
References: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com> <38b2ab8a0807240708j7d6782b7te6123fdd7416ec95@mail.gmail.com> <488891F2.9020509@windriver.com> <19f34abd0807240738h7ac5e716rcfa39d528b07870f@mail.gmail.com>
In-Reply-To: <19f34abd0807240738h7ac5e716rcfa39d528b07870f@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jul 2008 14:55:34.0306 (UTC) FILETIME=[5349E820:01C8ED9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Thu, Jul 24, 2008 at 4:30 PM, Jason Wessel
> <jason.wessel@windriver.com> wrote:
>   
>> Also, if you plan to use software breakpoints, please make sure to turn
>> off CONFIG_DEBUG_RODATA, else they will not work.   This is a regression
>> which will is on my list of things to take a look at, as time permits.
>>     
>
> I had a couple of kernels hang during single-stepping self-tests (I
> think), where it reached 500 and 900 tests respectively before it hung
> hard (NMI watchdog enabled, but not triggering). Is this related to
> the RODATA thing?
>
> This was with a recent (post-v2.6.26) kernel on a real P4.
>
>
>   

It is not likely that CONFIG_DEBUG_RODATA can have any impact because
the boot test occurs before the text sections are marked read-only.  A
hang in this section indicates a conflict where something is spinning
for a lock in the NMI handler, or the NMI handler re-entered and tried
to acquire another lock. 

In the 2.6.26 time frame I found and fixed at least one defect around
updating the clock while in the NMI which required that you not do it
from the NMI context.  It sounds as if there is yet another problem
along these lines, and of course it is a timing race...

Jason.
