Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbZESG1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbZESG1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 02:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZESG0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 02:26:55 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:35044 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831AbZESG0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 02:26:55 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: minyard@acm.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Openipmi-developer] modprobe ipmi_si hangs under 2.6.30-rc5
References: <87tz3qnh7o.fsf@tac.ki.iif.hu>
	<20090516170959.8057c9e4.akpm@linux-foundation.org>
	<877i0eqpss.fsf@tac.ki.iif.hu> <20090518184053.GA24134@minyard.local>
Date: Tue, 19 May 2009 08:26:39 +0200
In-Reply-To: <20090518184053.GA24134@minyard.local> (Corey Minyard's message
	of "Mon, 18 May 2009 13:40:54 -0500")
Message-ID: <87iqjxzjz4.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corey Minyard <minyard@acm.org> writes:

> On Mon, May 18, 2009 at 07:33:23PM +0200, Ferenc Wagner wrote:
>> Andrew Morton <akpm@linux-foundation.org> writes:
>> 
>>> Well there have only been a handful of changes to ipmi since 2.6.29. 
>>> Could you try a mini-bisection?
>>>
>>> Apply revert-1.patch, test
>>> Apply revert-2.patch, test
>>> Apply revert-3.patch, test
>>> Apply revert-4.patch, test
>> 
>> After applying revert-1.patch, modprobe runs OK:
>> 
>> [   86.968156] IPMI System Interface driver.
>> [   86.976276] ipmi_si: Trying SMBIOS-specified smic state machine at i/o address 0xecf4, slave address 0x20, irq 0
>> [   87.117630] ipmi: Found new BMC (man_id: 0x0002a2,  prod_id: 0x0000, dev_id: 0x00)
>> [   87.133078] IPMI smic interface initialized
>> 
>> I guess there's no point in trying the rest.
>
> I think I see the problem.  Can you try the patch at the end of the
> email?  I can't test it because I don't have an IPMI 1.0 sytem.

I tried your patch on top of 2.6.30-rc6.  Unfortunately it did not
help (nor made /proc/ipmi/ipmi0 appear at least).

>> When loading with debug options, it still produces insane amount of
>> debug messages continuously (first 671 lines of it attached).
>
> Yes, full debugging generates a ton of output, it logs everything it does
> in that case.

My concern is that it does something too often, not letting the CPU
enter deep sleep states, perhaps.  Or is that also an artifact of
debugging?
-- 
Thanks,
Feri.
