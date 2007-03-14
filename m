Return-Path: <linux-kernel-owner+w=401wt.eu-S932869AbXCNT2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbXCNT2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:28:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXCNT2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:28:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:31070 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbXCNT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EgQdJXHuM0Zs7LDFfLH47yP65v1slbJK+48BqM4JcJnl7JLdEs4egFAEC8pq2BtkGb9XTMwXPPd5PeyV4Myjj7bsLuzp5HkuOhJwPxm8kEZhugQeCZjhAaoksAGvUn4yP54AuIzbwzvBailkmxJqrcy4uq/F5C/9gv7dGgfgYA8=
Message-ID: <f2b55d220703141228q11c93c2i9b0b86d8953ab8b8@mail.gmail.com>
Date: Wed, 14 Mar 2007 12:28:01 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: f_mapping->host vs. f_path.dentry->d_inode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that there are (at least) two ways to get the inode (if
any) associated with an open file: f_mapping->host (pagecache?) and
f_path.dentry->d_inode (dentry cache?).  generic_file_llseek uses
f_mapping->host; everything else in read_write.c uses
f_path.dentry->d_inode.  do_sendfile checks for a null inode on its
input fd but not on its output fd; nothing else in read_write.c checks
for null inode.

Under what circumstances can f_mapping->host and f_path.dentry->d_inode differ?

Under what circumstances can either or both of these pointers be null?

Under what circumstances is it preferable to retrieve the inode from
f_mapping vs. f_path.dentry, either because they differ or because one
or the other is more likely to be warm in cache?

Cheers,
- Michael
