Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZARFaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZARFaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:30:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbZARFag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:30:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:33793 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZARFae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:30:34 -0500
Message-ID: <4972BE69.2000609@kernel.org>
Date: Sun, 18 Jan 2009 14:30:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] x86-64: Remove pda_init()
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>	 <1232115396-26367-6-git-send-email-brgerst@gmail.com>	 <1232115396-26367-7-git-send-email-brgerst@gmail.com>	 <1232115396-26367-8-git-send-email-brgerst@gmail.com>	 <1232115396-26367-9-git-send-email-brgerst@gmail.com>	 <1232115396-26367-10-git-send-email-brgerst@gmail.com>	 <1232115396-26367-11-git-send-email-brgerst@gmail.com>	 <1232115396-26367-12-git-send-email-brgerst@gmail.com>	 <1232115396-26367-13-git-send-email-brgerst@gmail.com>	 <4972B0E3.8060200@kernel.org> <73c1f2160901172120i174a8933qfdb51e654f13c785@mail.gmail.com>
In-Reply-To: <73c1f2160901172120i174a8933qfdb51e654f13c785@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 05:30:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Sat, Jan 17, 2009 at 11:32 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>> Brian Gerst wrote:
>>> -void __cpuinit pda_init(int cpu)
>>> -{
>>> -     struct x8664_pda *pda = cpu_pda(cpu);
>>> -
>>> -     /* Setup up data that may be needed in __get_free_pages early */
>>> -     loadsegment(fs, 0);
>>> -     loadsegment(gs, 0);
>>> -
>>> -     load_pda_offset(cpu);
>>> -}
>> Simply removing these should work fine as they're also initialized in
>> other places earlier but I think they still need to be in cpu_init()
>> because...
>>
>> /*
>>  * cpu_init() initializes state that is per-CPU. Some data is already
>>  * initialized (naturally) in the bootstrap process, such as the GDT
>>  * and IDT. We reload them nevertheless, this function acts as a
>>            ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>  * 'CPU state barrier', nothing should get across.
>>  * A lot of state is already set up in PDA init for 64 bit
>>  */
> 
> That comment seems like overkill.  It may have been relevant in an
> earlier time, but I don't think we need to be so strict now,
> especially for things we know are set properly in head_xx.S.

That may be so, but wouldn't such change deserve a separate patch with
accompanying update in the comment?  It's not simple move from A to B
change.

Thanks.

-- 
tejun
