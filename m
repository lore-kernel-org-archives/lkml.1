Return-Path: <linux-kernel-owner+w=401wt.eu-S1765406AbZDBQhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765406AbZDBQhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762315AbZDBQhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:37:34 -0400
Received: from h155.mvista.com ([63.81.120.155]:10110 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764553AbZDBQhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:37:32 -0400
Message-ID: <49D4E9EB.80207@ru.mvista.com>
Date: Thu, 02 Apr 2009 20:38:03 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49D4E0C3.7080808@ru.mvista.com> <20090402162846.GO2661@linux.intel.com>
In-Reply-To: <20090402162846.GO2661@linux.intel.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Matthew Wilcox wrote:

>>> +static int idedisk_prepare_discard(struct request_queue *q, struct 
>>>request *rq,
>>>+							struct bio *bio)

>>   Weird indentation.

> Not at all.  New line, so tab the next line over as far as it will go
> without falling off the 80-column limit.  It's fairly common.

> To quote Documentation/CodingStyle:

>   Statements longer than 80 columns will be broken into sensible chunks.
>   Descendants are always substantially shorter than the parent and are placed
>   substantially to the right. The same applies to function headers with a long
>   argument list. Long strings are as well broken into shorter strings.  The
>   only exception to this is where exceeding 80 columns significantly increases
>   readability and does not hide information.

    That's all clear, it's just that the second line was overly indented, at 
least to my taste. :-)

>>>+{
>>>+	ide_task_t *task;

>>   This patch is already obsolete as 'ide_task_t' is gone. Use 'struct  
>>ide_cmd' instead.

> Thanks, fixed.

>>>+	unsigned size;
>>>+	struct page *page = alloc_page(GFP_KERNEL);

>>   Missing empty line after the declaration block...

> Empty line not necessary.

    Usually it's there.

>>>+	task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
>>>+			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |

>>   The last 3 flags are going to be obsoleted too...

> So if I remove them today, the command will still work?

     s/obsoleted/renamed and moved to another other field/ -- I'm going to 
submit a patchset refactoring 'struct ide_cmd and 'struct ide-taskfile' at last...

MBR, Sergei
