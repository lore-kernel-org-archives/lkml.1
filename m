Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbZJUQ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbZJUQ12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 12:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbZJUQ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 12:27:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725AbZJUQ11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 12:27:27 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC V2 PATCH 2/5] cfq-iosched: preparation to handle multiple  service trees
References: <200910202012.00196.czoccolo@gmail.com>
	<x49iqe89313.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0910210925v7b44273flc22827d21fa1d6b9@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Oct 2009 12:27:26 -0400
In-Reply-To: <4e5e476b0910210925v7b44273flc22827d21fa1d6b9@mail.gmail.com>
	(Corrado Zoccolo's message of "Wed, 21 Oct 2009 18:25:47 +0200")
Message-ID: <x49y6n47lw1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
> On Wed, Oct 21, 2009 at 5:31 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>
>>> We embed a pointer to the service tree in each queue, to handle multiple
>>> service trees easily.
>>> Service trees are enriched with a counter.
>>> cfq_add_rq_rb is invoked after putting the rq in the fifo, to ensure
>>> that all fields in rq are properly initialized.
>>>
>>> @@ -115,6 +116,9 @@ struct cfq_queue {
>>>       unsigned short ioprio_class, org_ioprio_class;
>>>
>>>       pid_t pid;
>>> +
>>> +     struct cfq_rb_root *service_tree;
>>> +     struct cfq_io_context *cic;
>>>  };
>>
>> This change worries me.  For async queues, there is not a 1:1 mapping
>> between cfqq and cic.
>
> Currently, I need it only for sync queues. And it is used only to
> determine if a queue is seeky, so if we can mark it in the queue
> instead of the cic, this will not be needed any more.

Ah ha!  I have the same requirement for breaking the queues apart, so I
think this won't be an issue.

Thanks!
Jeff
