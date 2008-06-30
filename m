Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbYF3Irg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbYF3Irg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 04:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYF3IrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 04:47:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:26358 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYF3IrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 04:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fBdXhz0zm5GIka0iqKmWGGwLiZqiTQ3OQhZsPaCDJT5UmhPxOIz3F+ohng1mGD3ZQv
         uC4ZxClrME4s1tzxPR4t2RKEAYvQGeqDEh17irXqVqYk0XQUrT8vjJxjPbIIWgrRQ8Ms
         dp5jAxdNS2jMvK5bQ5+ulcYKQ3sTgzM6nAvEo=
Message-ID: <ac8af0be0806300147i1970a6f7mb705c0ce590326@mail.gmail.com>
Date: Mon, 30 Jun 2008 16:47:23 +0800
From: "Zhao Forrest" <forrest.zhao@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: Should a block device enforce block atomicity?
Cc: "Erez Zilber" <erezzi.list@gmail.com>,
       "Jens Axboe" <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <48689857.1050908@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ce513bcc0806292351t7f4ad933l920112381f4ebb4@mail.gmail.com>
	 <20080630065525.GI20826@kernel.dk>
	 <ce513bcc0806300058mbe0f15eya07fafbb9ba4a56@mail.gmail.com>
	 <48689857.1050908@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Don't forget that all IO requests are queued on the device. With a
> modern HW and disk you usually have NCQ and most drives will throw
> away write request to the same sector if they see a later write to
> the same sector in the queue.
>
> That said. There is nothing wrong with writing again and again to
> the same sector on disk. File/record locking is done at the FileSystem
> level. An application that wants exclusive write need to open the file
> that way. Other wise it could even be written from another machine not
> even another thread.
>
> What is it you are concerned with?
>
I happen to read the email and have a question, that may not be Erez's
real question :)
Let's suppose the following example:
1 pdflush find a dirty inode and decides to flush a set of dirty pages
to harddrive
2 while this set of dirty pages is being committed to
harddrive(dma_mapping is done, but dirty pages are not really written
to disk media), application/FS is trying to update some pages in this
set of dirty pages.

Then what happens? Will application be put into sleep until page
flushing to disk media is done?

Thanks,
Forrest
