Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXDJHfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXDJHfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbXDJHfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:35:40 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:48296 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbXDJHfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:35:40 -0400
Message-ID: <461B3E9C.5090606@sw.ru>
Date: Tue, 10 Apr 2007 11:37:00 +0400
From: Pavel Emelianov <xemul@sw.ru>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Lockdep treats down_write_trylock like regular down_write
References: <461A0DDC.5060709@sw.ru> <461A5733.3080303@linux.intel.com>
In-Reply-To: <461A5733.3080303@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Pavel Emelianov wrote:
>> This causes constructions like
>>
>> down_write(&mm1->mmap_sem);
>> if (down_write_trylock(&mm2->mmap_sem)) {
>>        ...
>>        up_write(&mm2->mmap_sem);
>> }
>> up_write(&mm1->mmap_sem);
>>
>> generate a lockdep warning about circular locking dependence.
> 
> please show me why this is safe, especially if you intermix it with
> down_read()'s... like copy_to_user and co may do.

This is safe as once the task locks the mm1->mmap_sem and gets
into '...' place it is *running* and will release booth semaphores
for sure.

> this feels like a very unsafe construct to me...
> 

