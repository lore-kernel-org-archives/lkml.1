Return-Path: <linux-kernel-owner+w=401wt.eu-S965701AbXDGJez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965701AbXDGJez (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965709AbXDGJez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:34:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:39896 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbXDGJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:34:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=BI3fjFz/lm+wXjk4tOP0SZCHYwS7lksZPt9ct9UoQiIIwlo1Z6FHVLpSvaFhU1zyK7knOAXQoQmc+3nEfypeXi7GX5uEE/AgkZ9eSjK7c0Wb9GoSyUrlq6z6lJBT/EtwTSoagFXl7KLD4iPt9ZuHaJYUGmakbKeKYVyVEiXIxAw=
Date: Sat, 7 Apr 2007 13:21:27 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: possible NULL pointer usage
Message-ID: <20070407092127.GA10229@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

from the function fs/udf/inode.c:udf_fill_inode -

	...

	UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
	memcpy(UDF_I_DATA(inode), bh->b_data + sizeof(struct extendedFileEntry), inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry));

	...

so that can lead to NULL pointer usage. udf_fill_inode()
declared as 'void' and the question I have is: what is the
best solution to deal with a situation if kmalloc failed?
May be just mark the node as bad by calling make_bad_inode()
and return from the function?


		Cyrill

