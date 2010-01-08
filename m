Return-Path: <linux-kernel-owner+w=401wt.eu-S1752896Ab0AHLDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0AHLDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 06:03:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465Ab0AHLDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 06:03:11 -0500
Received: from er-systems.de ([85.25.136.202]:46011 "EHLO er-systems.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab0AHLDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 06:03:11 -0500
Date: Fri, 8 Jan 2010 12:03:07 +0100 (CET)
From: Thomas Voegtle <tv@lio96.de>
To: Dmitry Monakhov <dmonakhov@openvz.org>
cc: Dmitry Monakhov <rjevskiy@gmail.com>, Greg KH <gregkh@suse.de>,
       Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: [PATCH] quota: fix reserved space management for ordinary fs
In-Reply-To: <87wrztpgbh.fsf_-_@openvz.org>
Message-ID: <alpine.LNX.2.00.1001081133180.1461@er-systems.de>
References: <20100106234533.GC1960@kroah.com> <alpine.LNX.2.00.1001071522480.5426@er-systems.de> <20100107180449.GA17495@suse.de> <alpine.LNX.2.00.1001072033301.26784@er-systems.de> <20100107194131.GA22983@suse.de> <alpine.LNX.2.00.1001072125040.26784@er-systems.de>
 <alpine.LNX.2.00.1001072141340.26784@er-systems.de> <20100107220213.GA24882@suse.de> <c18d6aa21001071603hbe4935clf78984fc837e4bd@mail.gmail.com> <87wrztpgbh.fsf_-_@openvz.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-Virus-Checker-Version: clamassassin 1.2.4 with clamdscan / ClamAV 0.95.3/10272/Fri Jan  8 06:21:23 2010 signatures .
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010, Dmitry Monakhov wrote:

>
> In fact inode_get_rsv_space() function is special in comparison
> with inode_{add,sub,claim}_rsv_space() functions, because
> it may return correct result even for fs without reserved space
> support(correct val == 0). Add trivial check for that case.
> The patch fix regression(BUG at fs/quota/dquot.c:1350) introduced
> in following commit: fd8fbfc1709822bd94247c5b2ab15a5f5041e103
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
> fs/quota/dquot.c |    2 ++
> 1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index dea86ab..d9f06cf 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -1377,6 +1377,8 @@ static void inode_sub_rsv_space(struct inode *inode, qsize_t number)
> static qsize_t inode_get_rsv_space(struct inode *inode)
> {
> 	qsize_t ret;
> +	if (!inode->i_sb->dq_op->get_reserved_space)
> +		return 0;
> 	spin_lock(&inode->i_lock);
> 	ret = *inode_reserved_space(inode);
> 	spin_unlock(&inode->i_lock);
>

Patch works for me on top of 2.6.33-rc3 and on top of 2.6.31.11.

Thanks,

Thomas


