Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbXCHR1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbXCHR1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 12:27:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591AbXCHR1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 12:27:39 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:12267 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbXCHR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 12:27:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=CK9RkJPamO8F0DqWJyAn266wJ0FkAjmsCYUuMHHu2cNZnzBW736/54be2LZHNfr30OD4lZ4LuxVgSreEIcrK6VSaoUi9K+dFvLgbAqaIsO0juL+/xfLrjdv1dc+rtXvnKEJgkdnu68r8I6wDkoAZkRhUeSiLU0tteH6LfooOTmM=
Message-ID: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
Date: Thu, 8 Mar 2007 17:27:37 +0000
From: "Catalin Marinas" <catalin.marinas@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Possible "struct pid" leak from tty_io.c
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

I'm trying to track down a kmemleak report (on an ARM platform) which
seems to have appeared with commit
ab521dc0f8e117fd808d3e425216864d60390500. As I'm not familiar with the
TTY layer at all, is it possible that the above commit missed a
put_pid() call on some path?

The /sbin/init application calls sys_clone() a few times but only one
leak is reported (see below). Looking at the reported pid object (at
0xc7c14500), count is 2 and nr is 296 but no process with pid 296
exists any more.

unreferenced object 0xc7c14500 (size 36):
  comm "init", pid 245, jiffies 4294939289
  backtrace:
    [<c0070c18>] kmem_cache_alloc
    [<c003a528>] alloc_pid
    [<c0026468>] do_fork
    [<c00153b0>] sys_clone
    [<c0010f80>] ret_fast_syscall

Thanks.

-- 
Catalin
