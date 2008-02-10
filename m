Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbYBJUB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbYBJUB3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 15:01:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYBJUBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 15:01:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:1209 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYBJUBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 15:01:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=bYf0IHTZx5VkLWxqaYJ9QkMugmAuEugf2JjA531RpHku7Ud4wak9tRabx2edsbFYhKWEbucY+GOC2nckeEWAI0npA7R3CpYzssicu5Z2NbIut5lYGzka4Hk7s3v0kll5nFvUKCNz4zRTQkQ+PrUbljBWijkHpCuyt7Uey3CGfus=
Date: Sun, 10 Feb 2008 23:00:52 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] udf: fix udf_add_free_space
Message-ID: <20080210200052.GA12569@cvg>
References: <20080210192721.GA9979@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210192721.GA9979@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Marcin Slusarz - Sun, Feb 10, 2008 at 08:27:33PM +0100]
| in commit 742ba02a51c8d0bf5446b154531179760c1ed0a2
| (udf: create common function for changing free space counter)
| by accident I reversed safety condition which lead to
| null pointer dereference in case of media error
| and wrong counting of free space in normal situation
| 
| Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
| Cc: Jan Kara <jack@suse.cz>
| ---
|  fs/udf/balloc.c |    2 +-
|  1 files changed, 1 insertions(+), 1 deletions(-)
| 
| diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
| index a95fcfe..1b809bd 100644
| --- a/fs/udf/balloc.c
| +++ b/fs/udf/balloc.c
| @@ -145,7 +145,7 @@ static bool udf_add_free_space(struct udf_sb_info *sbi,
|  {
|  	struct logicalVolIntegrityDesc *lvid;
|  
| -	if (sbi->s_lvid_bh)
| +	if (sbi->s_lvid_bh == NULL)
|  		return false;
|  
|  	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
| -- 

Marcin, actually you've confused me - i always thought the second case
is the explicit form of the first ;)

		- Cyrill -
