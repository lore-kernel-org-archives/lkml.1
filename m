Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbXGJXd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbXGJXd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 19:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762722AbXGJXbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 19:31:00 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58191 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762552AbXGJXa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 19:30:56 -0400
Date: Tue, 10 Jul 2007 16:30:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cmm@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [EXT4 set 4][PATCH 2/5] i_version: Add hi 32 bit inode version
 on ext4 on-disk inode
Message-Id: <20070710163047.1aba94f9.akpm@linux-foundation.org>
In-Reply-To: <1183275436.4010.127.camel@localhost.localdomain>
References: <1183275436.4010.127.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Jul 2007 03:37:16 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> This patch adds a 32-bit i_version_hi field to ext4_inode, which can be used for 64-bit inode versions. This field will store the higher 32 bits of the version, while Jean Noel's patch has added support to store the lower 32-bits in osd1.linux1.l_i_version.

Please wordwrap this changelog entry to less than 80 columns.  Well, less
than 258, anyway ;)

> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
> Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
> ---
> Index: linux-2.6.21/include/linux/ext4_fs.h
> ===================================================================
> --- linux-2.6.21.orig/include/linux/ext4_fs.h
> +++ linux-2.6.21/include/linux/ext4_fs.h
> @@ -342,6 +342,7 @@ struct ext4_inode {
>  	__le32  i_atime_extra;  /* extra Access time      (nsec << 2 | epoch) */
>  	__le32  i_crtime;       /* File Creation time */
>  	__le32  i_crtime_extra; /* extra FileCreationtime (nsec << 2 | epoch) */
> +	__le32	i_version_hi;	/* high 32 bits for 64-bit version */
>  };

Aren't there forward- backward-compatibility issues here?  How does the
filesystem driver work out whether this field is present and valid?

The changelog should describe this design issue.
