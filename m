Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbYA2PBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbYA2PBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:01:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbYA2PBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:01:43 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:54895 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYA2PBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:01:42 -0500
Message-ID: <479F3EFB.4070204@linux.vnet.ibm.com>
Date: Tue, 29 Jan 2008 20:28:03 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Reply-To: ciju@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: aglitke <agl@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] hugetlbfs :shmget with SHM_HUGETLB only works as
 root
References: <473B0317.6010603@linux.vnet.ibm.com> <1195054301.18047.20.camel@localhost.localdomain> <20071114220038.GD1806@holomorphy.com> <474F05C0.9040002@linux.vnet.ibm.com> <20071129231121.GA31637@holomorphy.com>
In-Reply-To: <20071129231121.GA31637@holomorphy.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Fri, Nov 30, 2007 at 12:02:32AM +0530, Ciju Rajan K wrote:
>>   I tested your patch. But that is not solving the problem.
>>   If the code change to user_shm_lock() is not a good solution, could 
>> you please suggest a method so that the normal user is able to allocate 
>> the huge pages, if his gid is added to /proc/sys/vm/hugetlb_shm_group
> 
> The patch I posted resolves a race unrelated to your issue. Raising your
> locked memory limits should not be difficult. /etc/limits.conf or similar
> should set it up for you. You can also change the default rlimit in the
> kernel and compile it with default limits elevated to what you want your
> unprivileged process to have to start with if you're truly having lots
> of trouble getting userspace to set the default limits properly. I'd
> look in include/asm-generic/resource.h
> 
> 
> -- wli

Hi Wli,

The documentation available in the kernel for huge pages does not talk
about the issue associated with locked memory limit. I think it would be
helpful to the users if we mention about this in the documentation. I
am attaching a small documentation patch.

Thanks
Ciju

Signed-off-by: Ciju Rajan (ciju@linux.vnet.ibm.com)
---
--- Documentation/vm/hugetlbpage.txt.orig       2008-01-24 16:42:40.000000000 +0530
+++ Documentation/vm/hugetlbpage.txt    2008-01-29 19:36:45.000000000 +0530
@@ -108,6 +108,18 @@ a supplementary group and system admin n
  applications to use any combination of mmaps and shm* calls, though the
  mount of filesystem will be required for using mmap calls.

+Note: The default locked limit in the kernel is just 32KB. If the normal
+user whose gid is present in the file /proc/sys/vm/hugetlb_shm_group needs
+more memory than this, the default limit must be increased. If pam is installed
+on your system, resource limits can be configured by installing lines similar
+to the following in /etc/security/limits.conf:
+
+@hugegroup      soft    memlock         2097152
+@hugegroup      hard    memlock         2097152
+
+Otherwise, you may manipulate the locked limit command directly with 'ulimit'.
+See its man page for more information.
+
  *******************************************************************

  /*

