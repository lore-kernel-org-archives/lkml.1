Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbYAOJMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbYAOJMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 04:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYAOJMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 04:12:05 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:12258 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYAOJMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 04:12:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M62SXAWObuXytWGQwMZNb6mmq8KTHGCGL4Hxn+QOMGoJXK4laANb4hylPbeOgzjVNeUa9rBQcQEaerttL5ORjd5ixW2fUF4E7ZXIoN+09/NqTV1TfPsCWJZGg3h6zBqd1UYY77Vz/xqFUTWzCk/C1zfsSV4UY6rT6Zmn8p0kbS8=
Message-ID: <9106c300801150112u7bf369e8rb01cd29a19c27e68@mail.gmail.com>
Date: Tue, 15 Jan 2008 17:12:01 +0800
From: "yawei niu" <yawei.niu@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: doesn't nfs_access_cache_shrinker() race with umount?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, NFS/VFS gurus

nfs_access_cache_shrinker() calls igrab() without serialized with
umount process, looks that might cause the "busy inode" after umount,
doesn't it?

I think we need to serialize the generic_shutdown_super() and
nfs_access_cache_shrinker() just like the dcache/icache shrinker, am I
understanding right?

Thanks
- Niu
