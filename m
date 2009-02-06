Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZBFWDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZBFWDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 17:03:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbZBFWDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 17:03:40 -0500
Received: from h155.mvista.com ([63.81.120.155]:31058 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753948AbZBFWDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 17:03:39 -0500
Message-ID: <498CB3CF.8070306@ru.mvista.com>
Date: Sat, 07 Feb 2009 01:03:59 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, geert@linux-m68k.org,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       apw@canonical.com
Subject: Re: [PATCH 01/15] ide: include <asm/ide.h> only when needed
References: <20090201174916.19144.11318.sendpatchset@localhost.localdomain> <200902052214.31483.bzolnier@gmail.com> <498B7D09.6040100@ru.mvista.com> <200902061721.46813.bzolnier@gmail.com>
In-Reply-To: <200902061721.46813.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

>>Hello.

>>Bartlomiej Zolnierkiewicz wrote:

>>>>>>>+#include <asm/ide.h>

>>>>>>Did you try checkpatch.pl?

>>>>>Sure.

>>>>>This driver uses stuff from <asm-mips/ide.h>.

>>>>>[ I guess I could put '-mips' there to silence warnings on tx493{8,9}.c,
>>>>>  however I don't know of the way to get rid of ide-io-std.c's one... ]

>>>>BTW, tx4939ide_{in,out}put_data_swap and
>>>>tx4939ide_{in,out}put_data_swap do exactly same thing.

>>>>If byte-swapped version of ide_{in,out}put_data() were available by
>>>>ide core, they can be used instead.  The byte-swapped version of
>>>>default_tp_ops would much helps such queer big-endian platforms.  Is
>>>>it worth to bloat ide core? ;-)

>>>Seems to be a good idea and it may also help some other host drivers
>>>(ide-h8300.c?).

>>   I'm not sure we need to carry the extra little used code just to help 
>>some exotic driver.

> It doesn't seem like we would need to carry any extra extra code for host
> drivers that don't need it because we have flexible Kconfig language to take
> care of such cases, i.e.

> ...
> config CONFIG_IDE_BE_IO
> 	bool

    If it was that simple... Normally the BE case gets handled automagically 
(moreover, there is MIPS option that additionally controls I/O and memory 
space byte swapping). The case we have to address for TX493x is actually where 
the usual magic fails (or actually the code just doesn't want to use that 
option). So this doesn't look like a good name to me...

> Thanks,
> Bart

WBR, Sergei
