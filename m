Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739Ab0ARCbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0ARCbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244Ab0ARCbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:31:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0ARCbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:31:46 -0500
Message-ID: <4B53C7E0.1090201@redhat.com>
Date: Mon, 18 Jan 2010 10:30:56 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
CC: Thomas Gleixner <tglx@linutronix.de>, damm@igel.co.jp,
       hsweeten@visionengravers.com, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] clockevents: fix clockevent_devices list corruption
 after cpu hotplug
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com> <alpine.LFD.2.00.0912101431380.3089@localhost.localdomain> <4B52D822.1010700@pardus.org.tr>
In-Reply-To: <4B52D822.1010700@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2010 05:28 PM, Ozan Çağlayan wrote:
> Thomas Gleixner wrote:
>
>>
>> I'm not happy about that churn. Why don't we simply scan the
>> clockevent_devices list for leftovers of the dead CPU ?
>>
>> Untested patch below solves the same problem.
>
>
> Hi, I have 3 bug reports about a clockevent failure while halting the system (2.6.31.11 kernel).
> It exactly pinpoints to the line 262 which got changed with this patch merged to 2.6.31.10 (and also 2.6.32.3):
>
> [4406.986777] kernel BUG at kernel/time/clockevents.c:262!
> [4406.986777] invalid opcode: 0000 [#1] SMP
> [4406.986777] last sysfs file: /sysfs/module/ip_tables/initstate

I think this one is duplicated of 
http://bugzilla.kernel.org/show_bug.cgi?id=15037
Thomas is working on the fix. I've sent a workaround patch on
http://patchwork.kernel.org/patch/71537/

>
>
> All 3 systems have Pentium 4 processors with different clock speeds.
>
> Here's a screenshot of the full stacktrace:
> http://bugs.pardus.org.tr/attachment.cgi?id=4820
>
> and the relevant bugzilla report:
> http://bugzilla.kernel.org/show_bug.cgi?id=15073
>
> Thanks,
> Ozan Caglayan
> Pardus Linux -- http://www.pardus.org.tr/eng
>

