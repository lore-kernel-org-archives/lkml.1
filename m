Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZJUQZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZJUQZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZJUQZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:25:45 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:56374 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZJUQZp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fZQMry6J/DoTP5luX8R95NZgaAaSGvF917ZfXZVnUyBkr/QpXeUSvZ8icAtBhcrw8a
         u4fJbng+DkDedKymXuZGp8O+yQPPwg1+9zyN4ttmqTmPxkqmbEq4GhMtbljObnkZQqbk
         uj5UJUUQsXvIDwo2gkphLVw4iOcktbxF4k834=
MIME-Version: 1.0
In-Reply-To: <x49iqe89313.fsf@segfault.boston.devel.redhat.com>
References: <200910202012.00196.czoccolo@gmail.com>
	 <x49iqe89313.fsf@segfault.boston.devel.redhat.com>
Date: Wed, 21 Oct 2009 18:25:47 +0200
Message-ID: <4e5e476b0910210925v7b44273flc22827d21fa1d6b9@mail.gmail.com>
Subject: Re: [RFC V2 PATCH 2/5] cfq-iosched: preparation to handle multiple 
	service trees
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
On Wed, Oct 21, 2009 at 5:31 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
>
>> We embed a pointer to the service tree in each queue, to handle multiple
>> service trees easily.
>> Service trees are enriched with a counter.
>> cfq_add_rq_rb is invoked after putting the rq in the fifo, to ensure
>> that all fields in rq are properly initialized.
>>
>> @@ -115,6 +116,9 @@ struct cfq_queue {
>>       unsigned short ioprio_class, org_ioprio_class;
>>
>>       pid_t pid;
>> +
>> +     struct cfq_rb_root *service_tree;
>> +     struct cfq_io_context *cic;
>>  };
>
> This change worries me.  For async queues, there is not a 1:1 mapping
> between cfqq and cic.

Currently, I need it only for sync queues. And it is used only to
determine if a queue is seeky, so if we can mark it in the queue
instead of the cic, this will not be needed any more.

>  With my forthcoming close cooperator changes, the
> same will be true for sync queues.
Yes, I saw it. This is currently just an RFC. If your changes got
merged before, I'll devise an alternative solution to this problem.

Corrado

> Cheers,
> Jeff
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
