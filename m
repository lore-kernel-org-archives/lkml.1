Return-Path: <linux-kernel-owner+w=401wt.eu-S1754334AbZIHKjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334AbZIHKjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZIHKjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:39:17 -0400
Received: from smtp.nokia.com ([192.100.122.233]:37413 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbZIHKjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:39:17 -0400
Message-ID: <4AA633FD.3080006@gmail.com>
Date: Tue, 08 Sep 2009 13:37:49 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Sep 2009 10:38:00.0100 (UTC) FILETIME=[6FA47640:01CA3070]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/08/2009 12:23 PM, Jens Axboe wrote:
> From: Theodore Ts'o<tytso@mit.edu>
>
> Originally, MAX_WRITEBACK_PAGES was hard-coded to 1024 because of a
> concern of not holding I_SYNC for too long.  (At least, that was the
> comment previously.)  This doesn't make sense now because the only
> time we wait for I_SYNC is if we are calling sync or fsync, and in
> that case we need to write out all of the data anyway.  Previously
> there may have been other code paths that waited on I_SYNC, but not
> any more.
>
> According to Christoph, the current writeback size is way too small,
> and XFS had a hack that bumped out nr_to_write to four times the value
> sent by the VM to be able to saturate medium-sized RAID arrays.  This
> value was also problematic for ext4 as well, as it caused large files
> to be come interleaved on disk by in 8 megabyte chunks (we bumped up
> the nr_to_write by a factor of two).
>
> So, in this patch, we make the MAX_WRITEBACK_PAGES a tunable,
> max_writeback_mb, and set it to a default value of 128 megabytes.
>
> http://bugzilla.kernel.org/show_bug.cgi?id=13930
>
> Signed-off-by: "Theodore Ts'o"<tytso@mit.edu>
> Signed-off-by: Jens Axboe<jens.axboe@oracle.com>

Would be nice to update doc files like

Documentation/sysctl/vm.txt
Documentation/filesystems/proc.txt

as well.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
