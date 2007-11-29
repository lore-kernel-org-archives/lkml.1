Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbXK2XM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbXK2XM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbXK2XMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:12:47 -0500
Received: from holomorphy.com ([66.93.40.71]:57810 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbXK2XMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:12:46 -0500
Date: Thu, 29 Nov 2007 15:11:21 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Cc: aglitke <agl@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] hugetlbfs :shmget with SHM_HUGETLB only works as root
Message-ID: <20071129231121.GA31637@holomorphy.com>
References: <473B0317.6010603@linux.vnet.ibm.com> <1195054301.18047.20.camel@localhost.localdomain> <20071114220038.GD1806@holomorphy.com> <474F05C0.9040002@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474F05C0.9040002@linux.vnet.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 12:02:32AM +0530, Ciju Rajan K wrote:
>   I tested your patch. But that is not solving the problem.
>   If the code change to user_shm_lock() is not a good solution, could 
> you please suggest a method so that the normal user is able to allocate 
> the huge pages, if his gid is added to /proc/sys/vm/hugetlb_shm_group

The patch I posted resolves a race unrelated to your issue. Raising your
locked memory limits should not be difficult. /etc/limits.conf or similar
should set it up for you. You can also change the default rlimit in the
kernel and compile it with default limits elevated to what you want your
unprivileged process to have to start with if you're truly having lots
of trouble getting userspace to set the default limits properly. I'd
look in include/asm-generic/resource.h


-- wli
