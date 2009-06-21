Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbZFUSnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbZFUSnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 14:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbZFUSnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 14:43:08 -0400
Received: from mga05.intel.com ([192.55.52.89]:2569 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751676AbZFUSnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 14:43:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,263,1243839600"; 
   d="scan'208";a="701250937"
Message-ID: <4A3E7F38.7030300@linux.intel.com>
Date: Sun, 21 Jun 2009 20:43:04 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, seto.hidetoshi@jp.fujitsu.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend
 to disk, 	mce related?
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
In-Reply-To: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> Tested kernel version: 2.6.30-git16 and 2.6.30-git17
> Last known good: 2.6.30
> 
> System hangs few minutes after resume from suspend to disk. 

Thanks for the report.

I assume it runs stable for hours without resume from disk?
And you made sure you don't use stale data from
a different kernel for resume from disk?

It is strange that resume from disk affects machine check.
How is your resume setup?
Do you have any init scripts that change machine check state
before the resume from disk runs?

Is there any chance you could configure netconsole or similar
to get output during the hang?

> I have
> tried bisection and here is result:

I assume you have CONFIG_X86_NEW_MCE enabled, correct?
Does it still happen with CONFIG_X86_OLD_MCE instead?

Also a "a few minutes" suggest something might be going wrong
with the poll handler.  Does the problem still happen
with you use CONFIG_X86_NEW_MCE again, but before
resume do

echo 0 > /sys/device/system/machinecheck/machinecheck0/check_interval

On the other hand you should get a crash very fast with

echo 1 > /sys/device/system/machinecheck/machinecheck0/check_interval

If we confirm it's the poll handler I can send you a debugging patch
to narrow it down further if I can't reproduce it.
But that would need console output during the crash.

Your dmesg also doesn't have anything related to resume from disk?

Thanks,

-Andi
