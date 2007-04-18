Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641AbXDREro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbXDREro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753317AbXDREro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:47:44 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:3099 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbXDRErn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:47:43 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Memory Allocation
Date: Tue, 17 Apr 2007 21:47:28 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEOPDBAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <14CFC56C96D8554AA0B8969DB825FEA002C99168@chicken.machinevisionproducts.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Tue, 17 Apr 2007 22:47:52 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Tue, 17 Apr 2007 22:47:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> My test machine is a Dell Precision 490 with dual 5140 processors and
> 3GB of RAM.  If I reduced kMaxSize to (2048 * 2048 * 236) is works.
> However, I need to allocate an array of char that is (2048 * 2048 * 256)
> and maybe even as large at (2048 * 2048 * 512).
>
> Obviously I have enough physical memory in the box to do this.  However,
> I suspect that I'm running out of page table entries.  Please, correct
> me if I'm wrong; but if I allocate (2048 * 2048 * 236) it work.  When I
> increment to 256 or 512 it fails and it is my suspicion that I just
> don't have enough more in kernel memory to allocate this much memory in
> user space.

It is unreasonable to expect single allocations this large to succeed on a
32-bit OS. Either get a 64-bit OS or use a number of smaller allocations.

You may want to use mmap'ed files instead of malloc'ed memory. You can them
mmap however many files you can at once, and unmap and remap them as needed.

DS



