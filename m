Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZEHEHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZEHEHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 00:07:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbZEHEGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 00:06:53 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60738 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbZEHEGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 00:06:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=ZQQ7uhBatmPBc5R7MGAsyrVpHkq1upKnifBlETkjZHEN2mKrHRpA4jJ/BoAhygBqFn
         b9pckLPklfUB9469k0JmC+o78ohUqBf/3TGc/tFZQ85vyTi5+YeB14uTX62JIy4fYpy5
         pw3+QMrejZ6FPIf3QJg1SRtK4y9mnQ+IS4bYw=
MIME-Version: 1.0
Date: Fri, 8 May 2009 09:36:52 +0530
Message-ID: <d51f89b0905072106q6f4c3eb8n663798c485f2ec44@mail.gmail.com>
Subject: issue with epoll syscall
From: rohit verma <rohit.170309@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all,

The man pages of epoll_create says - "Since Linux 2.6.8, the size
argument is unused.  (The kernel dynamically sizes the required data
structures without needing this initial hint.)" .

Also, it says that the syscall returns EINVAL , when size is not
positive. (i.e For, any value greater than 0, the kernel dynamically
sizes the required data stuctures). When size is zero or less than
zero, it has to return with error as EINVAL.

the latest patch of the epoll syscall tells:

asmlinkage long sys_epoll_create(int size)
{
- return sys_epoll_create2(size,0);
+ if (size < 0)
+  return -EINVAL;
+
+return sys_epoll_create1(0);
}

So if size = 0, it returns success which might not be the expected
result. So i feel that the condition check should be
" if (size <= 0) ". could u please check on this and reply me..

Thank you,

Regards,
rohit
