Return-Path: <linux-kernel-owner+w=401wt.eu-S1765164AbZDBQ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765164AbZDBQ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764739AbZDBQ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:28:49 -0400
Received: from mga10.intel.com ([192.55.52.92]:65075 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761510AbZDBQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:28:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="444418457"
Date: Thu, 2 Apr 2009 09:28:46 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com, David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [PATCH 4/5] ide: Add support for TRIM
Message-ID: <20090402162846.GO2661@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com> <1238683047-13588-2-git-send-email-willy@linux.intel.com> <1238683047-13588-3-git-send-email-willy@linux.intel.com> <1238683047-13588-4-git-send-email-willy@linux.intel.com> <49D4E0C3.7080808@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49D4E0C3.7080808@ru.mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 07:58:59PM +0400, Sergei Shtylyov wrote:
>>  +static int idedisk_prepare_discard(struct request_queue *q, struct 
>> request *rq,
>> +							struct bio *bio)
>
>    Weird indentation.

Not at all.  New line, so tab the next line over as far as it will go
without falling off the 80-column limit.  It's fairly common.

To quote Documentation/CodingStyle:

  Statements longer than 80 columns will be broken into sensible chunks.
  Descendants are always substantially shorter than the parent and are placed
  substantially to the right. The same applies to function headers with a long
  argument list. Long strings are as well broken into shorter strings.  The
  only exception to this is where exceeding 80 columns significantly increases
  readability and does not hide information.

>> +{
>> +	ide_task_t *task;
>
>    This patch is already obsolete as 'ide_task_t' is gone. Use 'struct  
> ide_cmd' instead.

Thanks, fixed.

>> +	unsigned size;
>> +	struct page *page = alloc_page(GFP_KERNEL);
>
>    Missing empty line after the declaration block...

Empty line not necessary.

>> +	if (!page)
>> +		goto error;
>
>    Unneeded goto -- why not just return?

Because it then looks the same as the other two cases where we can error
out.

>> +	task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
>> +			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
>
>    The last 3 flags are going to be obsoleted too...

So if I remove them today, the command will still work?
