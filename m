Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbYISMCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbYISMCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbYISMCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:02:48 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:55980 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751988AbYISMCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:02:47 -0400
Date: Fri, 19 Sep 2008 21:02:42 +0900 (JST)
Message-Id: <20080919.210242.57356043.taka@valinux.co.jp>
To: dm-devel@redhat.com
Cc: ryov@valinux.co.jp, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, fernando@oss.ntt.co.jp, xemul@openvz.org,
       agk@sourceware.org, balbir@linux.vnet.ibm.com
Subject: Re: [dm-devel] [PATCH 0/5] bio-cgroup: Introduction
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <20080919.200107.193703747.ryov@valinux.co.jp>
References: <20080919.200107.193703747.ryov@valinux.co.jp>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Hi everyone,
> 
> Here are new releases of bio-cgroup.
> Changes from the previous version are as follows:
> 
> - Accurate dirty-page tracking
>   Support migrating pages between bio-cgroups with minimum overhead,

I'm the one implementing this code.
The implementation isn't finished yet that this this code can't handle
mmapped file pages correctly. Actually, the same problem goes with
the task I/O accounting mechanism since the two of them are using
the same hook

This happens when starting to free pages under memory pressure.
Dirty bit of a pte will be moved into PG_Dirty flag of the associated
page. This can be done in another process context, while the hook try
to charge this operation to the current process.

>   but I think such a situation is quite rare.

I implemented it though, I don't think this case often happens since
it's not normal that several processes try to write the same block
of a file.


Thanks,
Hirokazu Takahashi.

