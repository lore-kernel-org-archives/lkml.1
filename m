Return-Path: <linux-kernel-owner+w=401wt.eu-S1753534AbZDNWOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbZDNWOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZDNWOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:14:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42880
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbZDNWOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:14:23 -0400
Date: Tue, 14 Apr 2009 15:14:15 -0700 (PDT)
Message-Id: <20090414.151415.267444590.davem@davemloft.net>
To: arnd@arndb.de
Cc: michal.simek@petalogix.com, linux-kernel@vger.kernel.org
Subject: Re: struct exception_table_entry
From: David Miller <davem@davemloft.net>
In-Reply-To: <200904141636.11676.arnd@arndb.de>
References: <49DE0EC4.4010409@petalogix.com>
	<200904141636.11676.arnd@arndb.de>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 14 Apr 2009 16:36:11 +0200

> On Thursday 09 April 2009, Michal Simek wrote:
> 
>> I am doing some cleanup things in MB MMU kernel and I looked at
>> exception_table_entry structure.
>> Only alpha use different types among others. Some arch use only
>> different names and types int/long.
>> I think that this structure could be moved to any generic location ->
>> asm-generic/uaccess.h folder.
>> 
>> I think that this structure types should be acceptable for every archs?
>> 
>> #ifndef exception_table_entry
>> struct exception_table_entry {
>>     unsigned long insn;
>>     unsigned long fixup;
>> };
>> #endif
>> 
>> What do you think?
> 
> Yes, sounds good to me. Have you tried using my generic version of
> uaccess.h on microblaze? It already contains a definition like this,
> though most of the header doesn't apply for MMU-based architectures.
> 
> I suppose it can be improved a bit, but should do the basic job.

Note that for space saving several 64-bit architectures use plain
"int" here when they know that all kernel addresses are in the low
32-bits of the address space.

sparc64 is one such architecture and I'd prefer if the size of these
tables does not bloat up when you guys try to make this thing generic.
