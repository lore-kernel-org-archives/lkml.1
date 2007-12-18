Return-Path: <linux-kernel-owner+w=401wt.eu-S935910AbXLRHLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935910AbXLRHLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:11:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbXLRHKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:10:51 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:31165 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbXLRHKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:10:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ocJaMT3Gm8Ctb61jPSI7U4t1LnittHpxsfp4CjAqcCMgaDj967zZ1zSZPa3RMVErzmwPQwTdo1+qjMIEQSCWADw9gKwXgp3cBOizIyKjr7CRBVPOAu5HuWVkvq5P0/EDUn0TBW1sVfAhGxIc7EvlVZx89GULvu+a5rNCkz8iMOY=
Message-ID: <105610bf0712172310ob56ae9ch4fa63e132011ae18@mail.gmail.com>
Date: Tue, 18 Dec 2007 15:10:50 +0800
From: wit <is01kzh@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: About mounting the sysfs
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
    Currently, I'm studying the code of the sysfs. But I got the
following questions:

1. What is the d_alloc_root used for? Actually, the question should
be: why we have to call d_alloc_root. I think the root already has its
dentry, why we have to allocate another while we mounting a file
system?

2. Why we call d_alloc_root to allocate a dentry for the mount point
while the usual mount point of sysfs is defined by the user (something
like /sysfs but not /). See below:
	root = d_alloc_root(inode);
	if (!root) {
		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
		iput(inode);
		return -ENOMEM;
	}
	root->d_fsdata = &sysfs_root;
	sb->s_root = root;

does this means settting the sysfs' mount point to "/" but not "/sysfs".

Thanks.

--Zhanhua
