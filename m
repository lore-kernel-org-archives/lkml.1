Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYDDGWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYDDGWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbYDDGWa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:22:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:55537 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbYDDGW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ari4aaizB12veT+t6sIH6Po/ssgSj4ofQ6tFvvMvcHv8q0Hx/JZ6UJ4FQd9CL2ooHcWhAYJMgQCSYWhJnpnjpcGLSSoJp+ndZ6PMwS4KDxycJiX+i4TUyaHgaoGvYwDpOMyO2scGchijcmhmbEIQtV2SNcv15t3z1tXZoqHH0J0=
Message-ID: <9c9fda240804032322x7316ff78lee646d22cb66178a@mail.gmail.com>
Date: Fri, 4 Apr 2008 15:22:20 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: joern@logfs.org
Subject: Re: [patch 5/15] fs/logfs/dir.c
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mtd@lists.infradead.org
In-Reply-To: <20080401181332.853833005@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080401181308.512473173@logfs.org>
	 <20080401181332.853833005@logfs.org>
X-Google-Sender-Auth: 2f671e556a178523
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's just quick view
>  +
>  +static int logfs_lookup_handler(struct inode *dir, struct dentry *dentry,
>  +               struct logfs_disk_dentry *dd, loff_t pos, void *arg)
>  +{
>  +       struct inode *inode;
>  +
>  +       inode = iget(dir->i_sb, be64_to_cpu(dd->ino));
>  +       if (!inode)
>  +               return -EIO;
>  +       return PTR_ERR(d_splice_alias(inode, dentry));
>  +}
>  +

The latest kernel doesn't have iget anymore. I saw some files use the
logfs_iget but dir.c, readwrite.c, ... uses the iget directly.
Please update this one.

Thank you,
Kyungmin Park
