Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbXCQKFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbXCQKFz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 06:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933700AbXCQKFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 06:05:55 -0400
Received: from ozlabs.org ([203.10.76.45]:35833 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933691AbXCQKFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 06:05:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17915.48105.70494.958220@cargo.ozlabs.ibm.com>
Date: Sat, 17 Mar 2007 20:59:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>,
       suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com,
       suzuki@in.ibm.com
Subject: Re: [RFC][PATCH] sys_fallocate() system call
In-Reply-To: <20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
References: <20070117094658.GA17390@amitarora.in.ibm.com>
	<20070225022326.137b4875.akpm@linux-foundation.org>
	<20070301183445.GA7911@amitarora.in.ibm.com>
	<20070316143101.GA10152@amitarora.in.ibm.com>
	<20070316161704.GE8525@osiris.boeblingen.de.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens writes:

> So you either rearrange the parameters or convert the loff_t's to pointers.
> 
> e.g.
> 
> asmlinkage long sys_fallocate(int fd, loff_t offset, loff_t len, int mode)
> 
> would work even on s390 ;)

... but wouldn't work on 32-bit powerpc. :(  We would end up with a
pad argument between fd and offset, giving 7 arguments in all
(counting the loff_t's as 2), but we only support 6.

Paul.
