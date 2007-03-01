Return-Path: <linux-kernel-owner+w=401wt.eu-S965519AbXCATQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965519AbXCATQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 14:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965517AbXCATQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 14:16:23 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965512AbXCATQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 14:16:22 -0500
Message-ID: <45E72647.9000001@redhat.com>
Date: Thu, 01 Mar 2007 13:15:19 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (Macintosh/20061207)
MIME-Version: 1.0
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC] Heads up on sys_fallocate()
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com>
In-Reply-To: <20070301183445.GA7911@amitarora.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Amit K. Arora wrote:
> This is to give a heads up on few patches that we will be soon coming up
> with. These patches implement a new system call sys_fallocate() and a
> new inode operation "fallocate", for persistent preallocation. The new
> system call, as Andrew suggested, will look like:
> 
>   asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len);
> 

One thing I'd like to see is a cmd argument as well, to allow for 
example allocation vs. reservation (i.e. allocating blocks vs. simply 
reserving a number), as well as the inverse of those functions 
(un-reservation, de-allocation)?

If the allocation interface allows allocation/reservation within 
arbitrary ranges, if the only way to un-allocate is via a truncate, 
that's pretty asymmetric.

-Eric
