Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbYCJEf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbYCJEf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 00:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbYCJEfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 00:35:51 -0400
Received: from ozlabs.org ([203.10.76.45]:43764 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbYCJEfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 00:35:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18388.47773.77106.664217@cargo.ozlabs.ibm.com>
Date: Mon, 10 Mar 2008 15:35:41 +1100
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       hans.rosenfeld@amd.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
In-Reply-To: <alpine.LFD.1.00.0803091007560.5896@woody.linux-foundation.org>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org>
	<20080303074620.GC5934@elte.hu>
	<20080303091304.GA17911@elte.hu>
	<47CC2A3D.1000307@linux.intel.com>
	<20080303174009.GA19131@elte.hu>
	<47CC451A.2060501@linux.intel.com>
	<alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org>
	<20080309115603.GA951@elte.hu>
	<alpine.LFD.1.00.0803091007560.5896@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> But even for PAGE_MASK, we literally have code like this:
> 
> 	if ((size_avail & PAGE_MASK) < rg.size) {
> 
> where it so _happens_ that "size_avail" is unsigned, but what if it 
> wasn't? It could turn a unsigned comparison into a signed one, and 
> introduce any number of security bugs etc.

We have had PAGE_MASK being signed on powerpc for ages, so if you do
find any such bugs, please let me know. :)  I'm not aware of any at
present, though.

The expression you quoted will be ok as long as either size_avail or
rg.size is unsigned, as far as I can see.

Our PAGE_SIZE is unsigned long.

Paul.
