Return-Path: <linux-kernel-owner+w=401wt.eu-S1423282AbXBHTxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423282AbXBHTxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423277AbXBHTxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:53:11 -0500
Received: from mail.parknet.jp ([210.171.160.80]:3998 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423282AbXBHTxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:53:09 -0500
X-AuthUser: hirofumi@parknet.jp
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Direct IO for fat
References: <20070208112808.GA3767@duck.suse.cz>
	<87k5ysfyd5.fsf@duaron.myhome.or.jp>
	<20070208161001.GB3767@duck.suse.cz>
	<87wt2sd2m8.fsf@duaron.myhome.or.jp>
	<20070208173515.GB3780@duck.suse.cz>
	<20070208184104.GA24986@atrey.karlin.mff.cuni.cz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Fri, 09 Feb 2007 04:53:02 +0900
In-Reply-To: <20070208184104.GA24986@atrey.karlin.mff.cuni.cz> (Jan Kara's message of "Thu\, 8 Feb 2007 19\:41\:04 +0100")
Message-ID: <873b5g2zq9.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> > -> blockdev_direct_IO()
>> >   -> direct_io_worker()
>> >     -> do_direct_IO()
>> >       -> get_more_blocks()
>> > 
>> > 		create = dio->rw & WRITE;
>>   Here, create == 1.
>> 
>> > 		if (dio->lock_type == DIO_LOCKING) {
>> > 			if (dio->block_in_file < (i_size_read(dio->inode) >>
>> > 							dio->blkbits))
>> > 				create = 0;
>>   But here create was reset back to 0 - exactly because
>> dio->block_in_file > i_size...
>   Obviously, I'm blind and you're right ;) This test is not satisfied
> and so create == 1.
>   But still it would seem better to me to return 0 from fat_direct_IO()
> instead of EINVAL so that write falls back to a buffered one, instead
> returning the error...

I see. When I wrote this, I thought kernel should use DIO to write if
user sets O_DIRECT. Because the wrong alignment request isn't fallback
to buffered-write, and it's also returns EINVAL.

But I don't have strong opinion here. If anyone (you) has any request
of it, I'll not have objection to it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
