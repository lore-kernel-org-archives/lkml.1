Return-Path: <linux-kernel-owner+w=401wt.eu-S1752131AbZHCG1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbZHCG1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 02:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbZHCG1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 02:27:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42593 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZHCG1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 02:27:37 -0400
Message-ID: <4A768339.9060904@zytor.com>
Date: Sun, 02 Aug 2009 23:27:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akinobu.mita@gmail.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86: Introduce GDT_ENTRY_INIT()
References: <20090718151219.GD11294@localhost.localdomain> <tip-d520da1173abd1f918b7e690220e14ba0fc56cfc@git.kernel.org> <20090803062024.GA22365@elte.hu>
In-Reply-To: <20090803062024.GA22365@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * tip-bot for Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 
>> Commit-ID:  d520da1173abd1f918b7e690220e14ba0fc56cfc
>> Gitweb:     http://git.kernel.org/tip/d520da1173abd1f918b7e690220e14ba0fc56cfc
>> Author:     Akinobu Mita <akinobu.mita@gmail.com>
>> AuthorDate: Sun, 19 Jul 2009 00:12:20 +0900
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Sun, 19 Jul 2009 18:27:53 +0200
>>
>> x86: Introduce GDT_ENTRY_INIT()
>>
>> GDT_ENTRY_INIT is static initializer of desc_struct.
>>
>> We already have similar macro GDT_ENTRY() but it's static
>> initializer for u64 and it cannot be used for desc_struct.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> LKML-Reference: <20090718151219.GD11294@localhost.localdomain>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>

OK, I spotted the following error, which certainly would explain a crash 
on an APM machine:

  	/* data */
-	[GDT_ENTRY_APMBIOS_BASE+2]	= { { { 0x0000ffff, 0x00409200 } } },
+	[GDT_ENTRY_APMBIOS_BASE+2]	= GDT_ENTRY_INIT(0x409a, 0, 0xffff),

Also, we shouldn't be initializing the A bits to clear unless we 
actually plan to check the A (and D) bits... that's just a waste of CPU 
cycles.

	-hpa


	-hpa
