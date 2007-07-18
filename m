Return-Path: <linux-kernel-owner+w=401wt.eu-S1764747AbXGROLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764747AbXGROLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbXGROLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:11:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:38329 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758936AbXGROLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:11:35 -0400
In-Reply-To: <200707181247.26262.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0707172353050.29097@blarg.am.freescale.net> <200707181247.26262.bzolnier@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <162F0B67-44AB-4955-873A-150224C128CB@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-ide@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: compile error if CONFIG_BLOCK not enabled related to linux/ide.h include
Date: Wed, 18 Jul 2007 09:12:02 -0500
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 18, 2007, at 5:47 AM, Bartlomiej Zolnierkiewicz wrote:

>
> Hi,
>
> On Wednesday 18 July 2007, Kumar Gala wrote:
>> M:      bzolnier@gmail.com
>> L:      linux-ide@vger.kernel.org
>>
>> We get the following compile error if CONFIG_BLOCK isn't enabled:
>>
>>   CC      arch/powerpc/kernel/setup_32.o
>> In file included from arch/powerpc/kernel/setup_32.c:14:
>> include/linux/ide.h:558: error: expected specifier-qualifier-list  
>> before 'request_queue_t'
>> include/linux/ide.h:696: warning: 'struct request' declared inside  
>> parameter list
>> include/linux/ide.h:696: warning: its scope is only this  
>> definition or declaration, which is probably not what you want
>> include/linux/ide.h:820: warning: 'struct request' declared inside  
>> parameter list
>> include/linux/ide.h:853: error: field 'wrq' has incomplete type
>> include/linux/ide.h:1205: error: expected ')' before '*' token
>> make[1]: *** [arch/powerpc/kernel/setup_32.o] Error 1
>> make: *** [arch/powerpc/kernel] Error 2
>
> include/linux/ide.h is exclusively for IDE subsystem
>
>> What I'm trying to figure out is if include/linux/ide.h should be  
>> wrapped
>> in a #if defined(CONFIG_IDE) || defined(CONFIG_IDE_MODULE) or if  
>> there is
>> some other desired way to handle this.
>
> Plese remove <linux/ide.h> include, there doesn't seem to be any  
> piece of
> code in arch/powerpc/kernel/setup_32.c which needs it anyway.

Its needed for:

struct ide_machdep_calls ppc_ide_md;

which gets defined in asm/ide.h which needs linux/ide.h for the defn  
of ide_init_hwif.

- k



