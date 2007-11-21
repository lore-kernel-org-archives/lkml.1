Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbXKUWRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbXKUWRR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 17:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXKUWRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 17:17:07 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:54237 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbXKUWRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 17:17:06 -0500
From: Wagner Ferenc <wferi@niif.hu>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: network driver usage count
References: <87hcjf9yd4.fsf@tac.ki.iif.hu>
	<20071121130445.569d2176@freepuppy.rosehill>
Date: Wed, 21 Nov 2007 23:16:59 +0100
In-Reply-To: <20071121130445.569d2176@freepuppy.rosehill> (Stephen Hemminger's
	message of "Wed, 21 Nov 2007 13:04:45 -0800")
Message-ID: <87myt7nt0k.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@linux-foundation.org> writes:

> On Wed, 21 Nov 2007 20:45:11 +0100
> Ferenc Wagner <wferi@niif.hu> wrote:
>
>> Under 2.6.23.1, my lsmod output shows this:
>> 
>> $ lsmod | grep tg3
>> tg3                   100580  0 
>> 
>> The usage count is zero, even though it drives my two physical
>> interfaces:
>> 
>> $ ls -l /sys/class/net/eth-gb?/device/driver
>> lrwxrwxrwx 1 root root 0 2007-11-21 19:58 /sys/class/net/eth-gb1/device/driver -> ../../../bus/pci/drivers/tg3
>> lrwxrwxrwx 1 root root 0 2007-11-21 19:58 /sys/class/net/eth-gb2/device/driver -> ../../../bus/pci/drivers/tg3
>> 
>> These interfaces are up and bonded together, but that doesn't seem to
>> matter at all.  I also checked other machines, the network driver
>> (tg3, e1000) usage counts are always zero under various recent 2.6
>> kernels, but nonzero under 2.4.21 for example.
>> 
>> And really, the module could be removed, cutting my ssh session. :)
>> 
>> Was this made possible intentionally?  If yes, why?
>
> Yes, so devices can be removed at anytime.

Hmm, that would warrant nuking all the reference counts on every
driver.  I must be missing something, since I really feel it goes
against common sense.  Can you point me to some discussion of this
change?  I mean, I couldn't remove the driver of a mounted filesystem.
So why can I remove a driver serving live network traffic?
-- 
Thanks,
Feri.
