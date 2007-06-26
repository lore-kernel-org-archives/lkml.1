Return-Path: <linux-kernel-owner+w=401wt.eu-S1754138AbXFZIUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbXFZIUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 04:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbXFZIUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 04:20:22 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:33282 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbXFZIUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 04:20:21 -0400
Message-ID: <4680CC51.1050205@alcatel-lucent.com>
Date: Tue, 26 Jun 2007 16:20:33 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: bugs in __schedule()
References: <4680C6F3.9000504@alcatel-lucent.com> <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>
In-Reply-To: <a781481a0706260118o2ef795bj579b3ec86c4fca8a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2007 08:20:15.0984 (UTC) FILETIME=[D34FAF00:01C7B7CA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the all output I have:

# ifconfig mgt0 10.0.51.27
BUG: scheduling while atomic: exe/0x00000101/752
caller is schedule+0x4c/0xe4
Call trace:
 [c02dc4dc] __schedule+0x654/0x788
 [c02dc6f4] schedule+0x4c/0xe4
 [c02dbe24] __compat_down+0xc8/0x12c
 [c0226b60] mv_sw_read_reg+0x178/0x17c
 [c02296fc] mvSwIntrTasklet+0x128/0x744
 [c0020afc] tasklet_action+0x7c/0xec
 [c00204f4] ___do_softirq+0x80/0x11c
 [c00205cc] __do_softirq+0x3c/0x6c
 [c00206a4] do_softirq+0x60/0x68
 [c00207a8] irq_exit+0x6c/0x94
 [c0005e1c] do_IRQ+0x88/0xa4
 [c0004b70] ret_from_except+0x0/0x18
 [c000680c] __delay+0xc/0x14
 [c0226598] mv_sw_read_smi_reg+0x84/0x1ac
 [c0226adc] mv_sw_read_reg+0xf4/0x17c


Satyam Sharma wrote:
> Hi Gavin,
>
> On 6/26/07, gshan <gshan@alcatel-lucent.com> wrote:
>> Anybody has suggestions on this crash?
>>
>> [c02dc4dc] __schedule+0x654/0x788
>>  [c02dc6f4] schedule+0x4c/0xe4
>>  [c02dbe24] __compat_down+0xc8/0x12c
>>  [c0226b60] mv_sw_read_reg+0x178/0x17c
>>  [c02296fc] mvSwIntrTasklet+0x128/0x744
>>  [c0020afc] tasklet_action+0x7c/0xec
>>  [c00204f4] ___do_softirq+0x80/0x11c
>>  [c00205cc] __do_softirq+0x3c/0x6c
>>  [c00206a4] do_softirq+0x60/0x68
>>  [c00207a8] irq_exit+0x6c/0x94
>>  [c0005e1c] do_IRQ+0x88/0xa4
>>  [c0004b70] ret_from_except+0x0/0x18
>>  [c000680c] __delay+0xc/0x14
>>  [c0226598] mv_sw_read_smi_reg+0x84/0x1ac
>
> I bet you got more output than that, didn't you? :-)
>
> Now I know this must be a "scheduling while interrupts disabled",
> but why not post the whole error message?
>
> [ Reminds me of the other thread where someone thought just mentioning
> the EIP without any backtrace / other messages was enough to resolve a
> boot-time panic. I agree they're all magicians on this list, but Gods 
> they're
> not ... ]
>
> BTW I don't see "mvSwIntrTasklet" anywhere on -rc6. Is this a -mm kernel?
>
> Cheers,
> Satyam

