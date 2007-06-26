Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbXFZIgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbXFZIgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXFZIgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:36:32 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:52018 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbXFZIgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:36:32 -0400
Message-ID: <4680D007.3040007@alcatel-lucent.com>
Date: Tue, 26 Jun 2007 16:36:23 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: bugs in __schedule()
References: <4680C6F3.9000504@alcatel-lucent.com>	 <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>	 <4680CC51.1050205@alcatel-lucent.com> <a781481a0706260125l76c5848aq85403a4ec94d57da@mail.gmail.com>
In-Reply-To: <a781481a0706260125l76c5848aq85403a4ec94d57da@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2007 08:36:05.0765 (UTC) FILETIME=[096CC350:01C7B7CD]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> Hi Gavin,
>
> On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
>> Here is the all output I have:
>>
>> # ifconfig mgt0 10.0.51.27
>> BUG: scheduling while atomic: exe/0x00000101/752
>
> Yup, you can't sleep in taskets, they're atomic.
>
>> caller is schedule+0x4c/0xe4
>> Call trace:
>>  [c02dc4dc] __schedule+0x654/0x788
>>  [c02dc6f4] schedule+0x4c/0xe4
>>  [c02dbe24] __compat_down+0xc8/0x12c
>
> So, you can't use / acquire semaphores in them. Use spinlocks.
> If the shared data is also accessed from process context, use
> spin_lock_bh() from the process context code.
>
> Satyam
Thanks, Satyam. So I can replace the tasklet with kernel thread?
