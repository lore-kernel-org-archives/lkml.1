Return-Path: <linux-kernel-owner+w=401wt.eu-S1765603AbXHWVTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765603AbXHWVTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbXHWVTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:19:40 -0400
Received: from host721684293.hns-noc-rev-lu.com ([72.168.93.42]:34036 "EHLO
	aexorsyst.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbXHWVTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:19:39 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Aug 2007 17:19:32 EDT
From: "John Z. Bohach" <jzb2@aexorsyst.com>
To: linux-kernel@vger.kernel.org
Subject: mode_t:  linux/types.h vs. glibc's sys/types.h
Date: Thu, 23 Aug 2007 14:12:11 -0700
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708231412.11752.jzb2@aexorsyst.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

I've tried googling for this, and searched the archives as well, but I 
haven't found a satisfactory answer.  My apologies if this is covered 
somewhere...

The kernel's linux/types.h resolves mode_t to __kernel_mode_t which is 
then defined as:

typedef unsigned short  __kernel_mode_t;

in linux/posix_types.h.

However, glibc's sys/types.h eventually (in bits/typesizes.h) resolves 
mode_t to:

#define __MODE_T_TYPE           __U32_TYPE

So, when I try to pass a mode_t type from kernel space to user space, 
the kernel sends a short when the user space expects an int.  I of 
course declare my variable as 'mode_t' both in my kernel module and in 
my user-space app., with the above inconsistency.

I can get around this easily enough by sending/receiving __u32, but I'm 
trying to be a little more type-safe...

Is this something that is intentional, or is this an inconsistency 
between linux and glibc?  I've verified this both on 2.6.16.47 and 
2.6.20.6.  Any ideas?

Thanks,
John
