Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYDBPdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYDBPdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYDBPdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:33:14 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:55413 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbYDBPdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:33:13 -0400
X-Greylist: delayed 1766 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 11:33:13 EDT
Message-ID: <47F3A02B.5070302@t-online.de>
Date: Wed, 02 Apr 2008 17:03:07 +0200
From: Bernd Schmidt <bernds_cb1@t-online.de>
User-Agent: Thunderbird 2.0.0.12 (X11/20080229)
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: David Howells <dhowells@redhat.com>, Greg Ungerer <gerg@snapgear.com>,
       David McCullough <David_Mccullough@securecomputing.com>,
       LKML <linux-kernel@vger.kernel.org>, Bryan Wu <Bryan.Wu@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: nommu: handling anonymous mmap clearing in userspace rather than
 kernel
References: <8bd0f97a0804011434r4869fbe8t89ade12c04c97f2@mail.gmail.com>	 <5516.1207146014@redhat.com> <8bd0f97a0804020747r2d7c2802pa18cf08eced3821b@mail.gmail.com>
In-Reply-To: <8bd0f97a0804020747r2d7c2802pa18cf08eced3821b@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: Jlv798Z1Zh1Wh5O3PxnHEkLd5XVkB0R+YnCS4FIpa-TXpRWQs+SAPlIa2C3IH3fwuH
X-TOI-MSGID: a885d2d8-f594-4bee-9f69-0056fcbcd432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Wed, Apr 2, 2008 at 10:20 AM, David Howells <dhowells@redhat.com> wrote:
>> Mike Frysinger <vapier.adi@gmail.com> wrote:
>>  > a workaround: introduce a new no-mmu-only mmap flag MAP_UNINITIALIZE
>>  > to signal to the kernel that it should skip the memset().  this way,
>>  > userspace malloc() can do mmap(MAP_ANONYMOUS|MAP_UNINITIALIZE) to get
>>  > large chunks of memory without affecting any other anonymous mmap()
>>  > call.
>>
>>  I think that's reasonable for NOMMU.  It's not like the process accessing the
>>  uninitialised memory is prevented from accessing anything it wants to anyway.
>>
>>  I would vote that the memset() should only be skipped if requested as there
>>  may be programs that call mmap(MAP_ANONYMOUS) expecting the memory they're
>>  given to be zeroed out.
> 
> in the second proposal, the C library would be expected to do this, so
> no programs would be broken.  but you're right that any program that
> invokes the mmap() syscall directly would not get zeroed memory ...
> but is anyone doing such a crazy thing, let alone on embedded ?

It's not a guarantee we should break.  What's wrong with just using the 
MAP_UNINITIALIZE code we have?


Bernd
-- 
This footer brought to you by insane German lawmakers.
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 40368
Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif
