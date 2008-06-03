Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbYFCEcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbYFCEcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 00:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751427AbYFCEb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 00:31:58 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38301 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYFCEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 00:31:57 -0400
X-AuditID: 0ac90648-add7dba000000c2f-da-4844c93c6fc5
Message-ID: <4844C938.7030401@hitachi.com>
Date: Tue, 03 Jun 2008 13:31:52 +0900
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       jbacik@redhat.com, cmm@us.ibm.com, tytso@mit.edu,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [PATCH 4/5] jbd: fix error handling for checkpoint io
References: <4843CE15.6080506@hitachi.com> <4843CFBD.7040706@hitachi.com> 
    <20080602124409.GL30613@duck.suse.cz>
In-Reply-To: <20080602124409.GL30613@duck.suse.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thank you for reviewing.

Jan Kara wrote:

>>@@ -347,6 +361,8 @@ restart:
>> 				break;
>> 			}
>> 			retry = __process_buffer(journal, jh, bhs,&batch_count);
>>+			if (retry < 0)
>>+				result = retry;
> 
>   Here you update result whenever retry is < 0 and below when result == 0.
> I think it's better to have these two consistent (not that it would be
> currently any functional difference).

I fixed it.

> Only please add a comment in front of
> log_do_checkpoint() that it's supposed to be called with j_checkpoint_mutex
> held so that EIO propagation works correctly.

I added a comment.

I'll send the revised patch soon.

Thanks,
-- 
Hidehiro Kawai
Hitachi, Systems Development Laboratory
Linux Technology Center

