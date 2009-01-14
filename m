Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZANRsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZANRsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbZANRrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:47:53 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49446 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZANRrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:47:52 -0500
Message-ID: <496E2530.4080205@redhat.com>
Date: Wed, 14 Jan 2009 11:47:28 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
References: <1231945948-23676-1-git-send-email-jack@suse.cz> <1231945948-23676-2-git-send-email-jack@suse.cz> <496E2276.8050309@redhat.com> <20090114174023.GK19950@duck.suse.cz>
In-Reply-To: <20090114174023.GK19950@duck.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara wrote:
> On Wed 14-01-09 11:35:50, Eric Sandeen wrote:
>> Jan Kara wrote:
>>> To be really safe that the data hit the platter, we should also flush drive's
>>> writeback caches on fsync and for O_SYNC files or O_DIRSYNC inodes.
>> Seems sane, but aren't we getting really divergent behavior here between
>> ext2, ext3, and ext4 w.r.t. drive cache flushing for sync paths?
>   Well, but ext3/4 should do a barrier on a transaction commit (if the user
> really cares about data integrity) and hence it implicitely does the same.
> 
> 									Honza

Sorry, just now catching up with that other thread, which addresses this
topic.  :)  But yes, this seems correct...  (OTOH, I thought SuSE was
carrying a patch which did add this blkdev_flush to sync for ext3...)

-Eric
