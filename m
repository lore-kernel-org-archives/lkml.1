Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYJUP3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYJUP3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 11:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYJUP3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 11:29:21 -0400
Received: from vsmtp03.dti.ne.jp ([202.216.231.138]:49233 "EHLO
	vsmtp03.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbYJUP3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 11:29:21 -0400
X-Greylist: delayed 887 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Oct 2008 11:29:21 EDT
From: hooanon05@yahoo.co.jp
To: linux-kernel@vger.kernel.org
Subject: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel thread
Date: Wed, 22 Oct 2008 00:14:31 +0900
Message-ID: <7123.1224602071@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello all,

When sysctl_overcommit_memory is set OVERCOMMIT_NEVER,
__vm_enough_memory() refers current->mm.

For example,
# exportfs -i -o ... localhost:/tmpfs
# mkdir /tmp/w
# mount -o ... localhost:/tmpfs /tmp/w
# yes > /tmp/w/fileA

In this case, NFSD (kernel thread) calls shmem_file_write() or
shmem_write_begin() and __vm_enough_memory() is called. But current->mm
is NULL and the kernel crashes.
If a user have to set OVERCOMMIT_NEVER, where should we fix?


Junjiro R. Okajima
