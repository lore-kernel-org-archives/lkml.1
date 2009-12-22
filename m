Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZLVMIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZLVMIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 07:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZLVMIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 07:08:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41431 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZLVMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 07:08:10 -0500
Date: Tue, 22 Dec 2009 12:08:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Liuwenyi <qingshenlwy@gmail.com>
Cc: chris.mason@oracle.com, joel.becker@oracle.com, cjb@laptop.org,
       jmorris@namei.org, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, onlyflyer@gmail.com, strongzgy@gmail.com
Subject: Re: [PATCHv2 02/12]posix_acl: Add the check items
Message-ID: <20091222120803.GR18217@ZenIV.linux.org.uk>
References: <4B2F619A.8000407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2F619A.8000407@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 07:52:58PM +0800, Liuwenyi wrote:
> @@ -102,12 +102,9 @@ static int btrfs_set_acl(struct btrfs_trans_handle
> *trans,
> char *value = NULL;
> mode_t mode;
> 
> - if (acl) {
> - ret = posix_acl_valid(acl);
> - if (ret < 0)
> - return ret;
> - ret = 0;
> - }
> + ret = posix_acl_valid(acl);
> + if (ret < 0)
> + return ret;

... and now you can't remove acl from btrfs inode.  At all.

NAK the entire series.  You are changing existing user-visible behaviour
for all filesystems for no reason and at least in this case it's clearly
wrong change.
