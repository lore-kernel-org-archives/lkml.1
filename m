Return-Path: <linux-kernel-owner+w=401wt.eu-S1759784AbXGPMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784AbXGPMgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbXGPMf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:35:58 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40838 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXGPMf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:35:57 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix wrong __splice_from_pipe() usage
References: <877ip1qj29.fsf@duaron.myhome.or.jp>
	<20070716063435.GG5328@kernel.dk> <87odiczkky.fsf@duaron.myhome.or.jp>
	<20070716111528.GD5195@kernel.dk>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 16 Jul 2007 21:35:52 +0900
In-Reply-To: <20070716111528.GD5195@kernel.dk> (Jens Axboe's message of "Mon\, 16 Jul 2007 13\:15\:28 +0200")
Message-ID: <87hco4v847.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

>> nfsd_vfs_read() path.
>> 
>> nfsd_vfs_read()
>>     splice_direct_to_actor()
>>         while(len) {
>>             do_splice_to()                     [update sd->pos]
>>                 -> generic_file_splice_read()  [read from sd->pos]
>>             nfsd_direct_splice_actor()
>>                 -> __splice_from_pipe()        [update sd->pos]
>>         }
>> 
>> do_splice_to() updates sd->pos for read, and pass updated sd to
>> __splice_from_pipe(), and __splice_from_pipe() updates sd->pos for
>> write. So, next do_splice_to() read from wrong position.
>
> Ah, I see. Copying the structure over would work, but it seems like a
> big work-around for something that is essentially bad behaviour in the
> splice core for direct splicing.
>
> Can you check if this works for you?

Simple test was done. The patch works for me.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
