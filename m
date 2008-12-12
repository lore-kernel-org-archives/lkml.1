Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYLLBtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYLLBtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 20:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYLLBtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 20:49:02 -0500
Received: from mail.tpi.com ([198.107.51.143]:2195 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755210AbYLLBtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 20:49:00 -0500
Message-ID: <4941C301.3050909@canonical.com>
Date: Thu, 11 Dec 2008 17:48:49 -0800
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Michael Halcrow <mhalcrow@us.ibm.com>
CC: Duane Griffin <duaneg@dghda.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>,
       Mike.Halcrow.mhalcrow@us.ibm.com,
       Phillip.Hellewell.phillip@hellewell.homeip.net,
       ecryptfs-devel@lists.sourceforge.net, stable@kernel.org
Subject: Re: [PATCH] eCryptfs: check readlink result was not an error	before
 using it
References: <1229022995-9898-1-git-send-email-duaneg@dghda.com> <1229022995-9898-2-git-send-email-duaneg@dghda.com> <1229022995-9898-3-git-send-email-duaneg@dghda.com> <20081211193228.GA13627@halcrowt61p.lan>
In-Reply-To: <20081211193228.GA13627@halcrowt61p.lan>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Halcrow wrote:
> On Thu, Dec 11, 2008 at 07:16:26PM +0000, Duane Griffin wrote:
>> The result from readlink is being used to index into the link name
>> buffer without checking whether it is a valid length. If readlink
>> returns an error this will fault or cause memory corruption.
>>
>> Signed-off-by: Duane Griffin <duaneg@dghda.com>
> 
> Acked-by: Michael Halcrow <mhalcrow@us.ibm.com>
> 
>> ---
>>  fs/ecryptfs/inode.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
>> index 89209f0..5e78fc1 100644
>> --- a/fs/ecryptfs/inode.c
>> +++ b/fs/ecryptfs/inode.c
>> @@ -673,10 +673,11 @@ static void *ecryptfs_follow_link(struct dentry *dentry, struct nameidata *nd)
>>  	ecryptfs_printk(KERN_DEBUG, "Calling readlink w/ "
>>  			"dentry->d_name.name = [%s]\n", dentry->d_name.name);
>>  	rc = dentry->d_inode->i_op->readlink(dentry, (char __user *)buf, len);
>> -	buf[rc] = '\0';
>>  	set_fs(old_fs);
>>  	if (rc < 0)
>>  		goto out_free;
>> +	else
>> +		buf[rc] = '\0';
>>  	rc = 0;
>>  	nd_set_link(nd, buf);
>>  	goto out;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Please add 'Cc: stable@kernel.org' in the commit message. This looks
like a good candidate.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
