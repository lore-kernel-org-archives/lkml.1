Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbZDWPhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbZDWPhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZDWPg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:36:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65453 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbZDWPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:36:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=O2V9JuhgkQTAedw2ChNZ0VKLNhThlw5z7Zn093eB6sTMxAI786a9d/DYrLZt0krpzi
         2EMdH6BNH98ayB5EHXdr329v+mddtJHZ2lE105jwwr0Y3M2RCsVb1LoPJkYiKJLrJegu
         YxN7bYho7AtsD10lOBqK+tkpplpKRQSceViL8=
Message-ID: <49F08B15.4080808@gmail.com>
Date: Thu, 23 Apr 2009 17:36:53 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.3 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: e1000-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: e1000: "eeprom checksum is not valid" after kexec
References: <49F06EEB.9060500@gmail.com> <200904231715.44918.rjw@sisk.pl>
In-Reply-To: <200904231715.44918.rjw@sisk.pl>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2009 05:15 PM, Rafael J. Wysocki wrote:
> On Thursday 23 April 2009, Jiri Slaby wrote:
>> 4a865905f685eaefaedf6ade362323dc52aa703b
>> (PCI PM: Make pci_set_power_state() handle devices with no PM support)
>> breaks e1000 after being kexec'ed. These reverts fix the problem:
>>     Revert "PCI PM: Make pci_set_power_state() handle devices with no PM
>> support"
>>     Revert "PCI PM: Introduce __pci_[start|complete]_power_transition()
>> (rev. 2)"
>>
>> I reverted the second one
> 
> I don't think it can be reverted.

But it works :). I'm not saying, it's correct to revert them upstream.
It was just confirmation, that it causes the problem.

>> just for an easy revert of the former one, which is actually the culprit.
> 
> Can you just try to revert the changes in pci_raw_set_power_state() and check
> if that has any effect (it shouldn't)?

Please send a patch. I'm lost in the changes done there. Let's say
against the top of 20090423 next tree.

>> e1000: 0000:02:01.0: e1000_probe: Invalid MAC Address
>> e1000: 0000:02:01.0: e1000_probe: (PCI-X:33MHz:64-bit) 00:00:00:00:00:00
> 
> So this is after kexec?

yes

> What happens if you remove just the
> 
> 	/* Check if we're already there */
> 	if (dev->current_state == state)
> 		return 0;
> 
> part from pci_set_power_state()?

Will try later.

Thanks.
