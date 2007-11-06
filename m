Return-Path: <linux-kernel-owner+w=401wt.eu-S1756798AbXKFVnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756798AbXKFVnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 16:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXKFVnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 16:43:11 -0500
Received: from ithilien.qualcomm.com ([129.46.51.59]:43741 "EHLO
	ithilien.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbXKFVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 16:43:10 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 16:43:10 EST
Message-ID: <4730DFE2.9070202@qualcomm.com>
Date: Tue, 06 Nov 2007 13:42:58 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070926)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Strange freezes (seems like SATA related)
References: <47261043.5020907@qualcomm.com> <20071101164046.462f40f0.akpm@linux-foundation.org>
In-Reply-To: <20071101164046.462f40f0.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Mon, 29 Oct 2007 09:54:27 -0700
> Max Krasnyansky <maxk@qualcomm.com> wrote:
> 
>> A couple of HP xw9300 machines (dual Opterons) started freezing up.
>> We're running on 2.6.22.1 on them. Freezes a somewhere weird. VGA console is alive
>> (I can switch vts, etc) but everything else is dead (network, etc).
>> Unfortunately SYSRQ was not enabled and I could not get backtraces and stuff.
>>
>> Hooked up serial console and the only error that shows up is this.
>>
>> ata1: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1581000 status 0x1540 next cpb count 0x0 next cpb idx 0x0
>> ata1: CPB 0: ctl_flags 0xd, resp_flags 0x1
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata1.00: cmd ca/00:08:57:00:80/00:00:00:00:00/e0 tag 0 cdb 0x0 data 4096 out
>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>> Descriptor sense data with sense descriptors (in hex):
>> end_request: I/O error, dev sda, sector 8388695
>> Buffer I/O error on device sda1, logical block 1048579
>> lost page write due to I/O error on sda1
>> sd 0:0:0:0: [sda] Write Protect is off
>>
>> I see a bunch of those and then the box just sits there spewing this periodically
>>
>> ata1: EH in ADMA mode, notifier 0x1 notifier_error 0x0 gen_ctl 0x1581000 status 0x1540 next cpb count 0x0 next cpb idx 0x0
>> ata1: CPB 0: ctl_flags 0xd, resp_flags 0x1
>> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>> ata1.00: cmd ca/00:08:4f:00:f8/00:00:00:00:00/e1 tag 0 cdb 0x0 data 4096 out
>>          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
>>
>> SMART selftest on the drive passed without errors.
>>
>> Here is how this machine looks like
>>
>> ...
> 
> So this happens on more than one machine?
Yep.

> The kernel shouldn't freeze, so even if both machines have magically
> identical hardware faults, there's a kernel bug there somewhere.
> 
> I guess it would be useful to test a 2.6.23 kernel if poss.  We've seen a
> very large number of reports like this one in recent months (many of which
> have not been responded to, btw) and perhaps someone has done something
> about them.
I may not be able to run identical workload on 2.6.23. Will try to give it a shot
sometime next week. Also I've upgraded to 2.6.22.10 last week. There are a few fixes 
in there that may potentially affect those boxes.

Max



