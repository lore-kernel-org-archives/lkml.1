Return-Path: <linux-kernel-owner+w=401wt.eu-S1759691AbYESWx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691AbYESWx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753139AbYESWxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:53:17 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:46643 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYESWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=O0fuKOKOsiVoMm/q13GGlxDlNkDtk8y96/AMuiILNIPbPzkXd3RJj2/az5peKije9rFAMCsC21Uv7ow/p3SFq61O31o4ADlq+yiG0eKP+RT+BTVLuovLBHNNyiE56rVB5TTaMRs4GK06OpOW4hEiyELk442OMxDyNxVDTZzqvXo=
Message-ID: <9a8748490805191553l7d82a410t16fd854de980fe53@mail.gmail.com>
Date: Tue, 20 May 2008 00:53:11 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Abdel Benamrouche" <draconux@gmail.com>
Subject: Re: [PATCH] /fs/partition/check.c: fix return value warning
Cc: "Andrew Morton" <akpm@linux-foundation.org>, aeb@cwi.nl,
       linux-kernel@vger.kernel.org, trivial@kernel.org
In-Reply-To: <20080512152743.3c6b8adc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210419653-19234-1-git-send-email-draconux@gmail.com>
	 <20080512152743.3c6b8adc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Abdel,

2008/5/13 Andrew Morton <akpm@linux-foundation.org>:
> On Sat, 10 May 2008 13:40:53 +0200
> Abdel Benamrouche <draconux@gmail.com> wrote:
>
>> fs/partitions/check.c:381: warning: ignoring return value of ___device_add___,
>>  declared with attribute warn_unused_result
>>
>> Signed-off-by: Abdel Benamrouche <draconux@gmail.com>
>> ---
>> :100644 100644 6149e4b... 7a87fad... M        fs/partitions/check.c
>>  fs/partitions/check.c |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/partitions/check.c b/fs/partitions/check.c
>> index 6149e4b..7a87fad 100644
>> --- a/fs/partitions/check.c
>> +++ b/fs/partitions/check.c
>> @@ -378,7 +378,13 @@ void add_partition(struct gendisk *disk, int part, sector_t start, sector_t len,
>>
>>       /* delay uevent until 'holders' subdir is created */
>>       p->dev.uevent_suppress = 1;
>> -     device_add(&p->dev);
>> +     if (device_add(&p->dev)) {
>> +             put_device(&p->dev);
>> +             free_part_stats(p);
>> +             kfree(p);
>> +             return;
>> +     }
>> +
>>       partition_sysfs_add_subdir(p);
>>       p->dev.uevent_suppress = 0;
>>       if (flags & ADDPART_FLAG_WHOLEDISK)
>
> We should go further than this.  add_partition() just drops the error
> on the floor.  It should be propagated back to callers, and callers
> should be modified to handle it appropriately.
>
> Presumably we should also handle a device_create_file() failure as well
> - that is presently being silently ignored.
>

Given these comments from Andrew, I'm not adding this patch to the Trivial tree.
Please address Andrews comments and re-submit - at which point I doubt
it'll be suitable for trivial, so please try to get it merged via
other maintainers.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
