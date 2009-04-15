Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZDOG0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZDOG0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZDOG0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:26:17 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34703 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbZDOG0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:26:16 -0400
Message-ID: <49E57E05.60400@petalogix.com>
Date: Wed, 15 Apr 2009 08:26:13 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: struct exception_table_entry
References: <49DE0EC4.4010409@petalogix.com>	<200904141636.11676.arnd@arndb.de> <20090414.151415.267444590.davem@davemloft.net>
In-Reply-To: <20090414.151415.267444590.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Tue, 14 Apr 2009 16:36:11 +0200
>
>   
>> On Thursday 09 April 2009, Michal Simek wrote:
>>
>>     
>>> I am doing some cleanup things in MB MMU kernel and I looked at
>>> exception_table_entry structure.
>>> Only alpha use different types among others. Some arch use only
>>> different names and types int/long.
>>> I think that this structure could be moved to any generic location ->
>>> asm-generic/uaccess.h folder.
>>>
>>> I think that this structure types should be acceptable for every archs?
>>>
>>> #ifndef exception_table_entry
>>> struct exception_table_entry {
>>>     unsigned long insn;
>>>     unsigned long fixup;
>>> };
>>> #endif
>>>
>>> What do you think?
>>>       
>> Yes, sounds good to me. Have you tried using my generic version of
>> uaccess.h on microblaze? It already contains a definition like this,
>> though most of the header doesn't apply for MMU-based architectures.
>>
>> I suppose it can be improved a bit, but should do the basic job.
>>     
>
> Note that for space saving several 64-bit architectures use plain
> "int" here when they know that all kernel addresses are in the low
> 32-bits of the address space.
>   
Just one my note: use u32 instead of int.

Michal
> sparc64 is one such architecture and I'd prefer if the size of these
> tables does not bloat up when you guys try to make this thing generic.
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

