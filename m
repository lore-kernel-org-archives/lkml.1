Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbZEGHK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbZEGHK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZEGHKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:10:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:37734 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZEGHKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:10:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cNbEtPn4KOAkIucR+P0HDeVHbj/tPtdN9504RN0lmpVso2We7voF6kUww4zxr36dx2
         6OMEZHTye5/nDEni8qjk4gIERVTTk9dYbdAULZiOh8z2srWh+gIglIuDSY4jxA+wO6fE
         222sgRVVp89GNQsQaWCS6HlRsoccJ4iPDptAk=
MIME-Version: 1.0
Date: Thu, 7 May 2009 12:40:06 +0530
Message-ID: <d51f89b0905070010h3164a75va982f82c6f0b7900@mail.gmail.com>
Subject: issue with epoll system call
From: rohit verma <rohit.170309@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

The man pages of epoll_create says - "Since Linux 2.6.8, the size
argument is unused.  (The kernel dynamically sizes the required data
structures without needing this initial hint.)" .

Also, it says that the syscall returns EINVAL , when size is not
positive. (i.e For, any value greater than 0, the kernel dynamically
sizes the required data stuctures). When size is zero or less than
zero, it has to return with error as EINVAL.

the link:  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=e38b36f325153eaadd1c2a7abc5762079233e540

shows the latest patch of the epoll syscall. here , the syscall says:

asmlinkage long sys_epoll_create(int size)
{
- return sys_epoll_create2(size,0);
+ if (size < 0)
+  return -EINVAL;
+
+return sys_epoll_create1(0);
}

So if size = 0, it returns success which might not be the expected
result. So i feel that the condition check should be
" if (size <= 0) ". could u please check on this and reply me..

Thank you,

Regards,
rohit
