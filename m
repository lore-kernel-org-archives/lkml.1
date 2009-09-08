Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbZIHK3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbZIHK3M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZIHK3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:29:12 -0400
Received: from smtp.nokia.com ([192.100.122.230]:55804 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbZIHK3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:29:11 -0400
Message-ID: <4AA631AA.6000803@gmail.com>
Date: Tue, 08 Sep 2009 13:27:54 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz
Subject: Re: [PATCH 1/8] writeback: get rid of generic_sync_sb_inodes() export
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com> <1252401791-22463-2-git-send-email-jens.axboe@oracle.com>
In-Reply-To: <1252401791-22463-2-git-send-email-jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 08 Sep 2009 10:28:09.0178 (UTC) FILETIME=[0F6CEBA0:01CA306F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On 09/08/2009 12:23 PM, Jens Axboe wrote:
>   	int i, err;
>   	struct ubifs_info *c = sb->s_fs_info;
> -	struct writeback_control wbc = {
> -		.sync_mode   = WB_SYNC_ALL,
> -		.range_start = 0,
> -		.range_end   = LLONG_MAX,
> -		.nr_to_write = LONG_MAX,
> -	};
>
>   	/*
>   	 * Zero @wait is just an advisory thing to help the file system shove
> @@ -462,7 +456,7 @@ static int ubifs_sync_fs(struct super_block *sb, int wait)
>   	 * the user be able to get more accurate results of 'statfs()' after
>   	 * they synchronize the file system.
>   	 */
> -	generic_sync_sb_inodes(sb,&wbc);
> +	sync_inodes_sb(sb);

This call is unnecessary and I've removed it and the patch is sitting in
linux-next for long time:
http://git.infradead.org/ubifs-2.6.git/commit/887ee17117fd23e962332b353d250ac9e090b20f

Stephen e-mailed about the conflict recently. Could we please resolve the
conflict? I guess if you pick up my patch then git will be able to resolve
stuff automatically.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
