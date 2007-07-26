Return-Path: <linux-kernel-owner+w=401wt.eu-S1765544AbXGZRnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765544AbXGZRnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934169AbXGZRn0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:43:26 -0400
Received: from homer.mvista.com ([63.81.120.155]:36005 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933689AbXGZRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:43:24 -0400
Message-ID: <46A8DDB4.30306@ru.mvista.com>
Date: Thu, 26 Jul 2007 21:45:24 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Scott Wood <scottwood@freescale.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] MPC8349E-mITX: use platform IDE driver
 for CF	interface
References: <20070725165318.5331.23795.stgit@localhost.localdomain>	<20070725165326.5331.19920.stgit@localhost.localdomain>	<46A78322.3080607@ru.mvista.com>	<46A78E3F.1030904@ru.mvista.com>	<20070725180145.GA29689@ld0162-tx32.am.freescale.net>	<46A7968D.3070707@ru.mvista.com>	<46A79AA1.3030608@freescale.com> <20070726212118.7fe7abd3@localhost.localdomain>
In-Reply-To: <20070726212118.7fe7abd3@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Vitaly Bordug wrote:

>>>   I acn undertand your complaint in the context of an OF driver
>>>(which we don't have yet) but "mmio-ide" just means nothing to the
>>>current driver, and it doesn't convery enough info on the
>>>programming interface for the conceivable OF driver, it also does
>>>need to know at least "reg-stride" (and maybe "reg-size" in case
>>>only 16/32-bit accesses can be used).  Well, if such driver will be
>>>written, I/O mapping support will probably be dropped from it, so
>>>indeed, calling it mmio-ide.c would make sense.  But that can be
>>>added when this driver is done, and for now 

>>I don't think the details of what Linux code currently exists should 
>>drive the device tree binding.  That the current patches use 
>>platform_device glue code is an implementation detail (and one I'd 
>>rather see go away, in favor of a driver that supports both 
>>platform_device and of_device).

>>>I'd really prefer the board name to appear in the "compatible" prop
>>>(to which "mmio-ide" can be appended)...

>>Sure, that's always good...  it was the "instead" that I objected to.

> Hmmm. So what is finally suggested devicetree node for this beast - can somebody refine?

> I am a little bit confused about decided device_type

    My understanding is that "ata" has been already used, so there's no sense 
in introducing "ide". Anyway, Segher will just say that "device_type" shoudn't 
matter and even be present. ;-)

 > and compatible fields...

    In my understanding, as "mmio-ide" currectly makes no sense, it shouldn't 
even appear there.  And since "mpc8349emitx-cf" (or whatever would be most 
generic name for those boards with the same type of CF IDE mapping) should be 
imply the shift value, this property should also be optional, i.e. passing 
hard coded value with platform_device would do.

MBR, Sergei
