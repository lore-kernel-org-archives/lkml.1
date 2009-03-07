Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZCGXwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZCGXwg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 18:52:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZCGXw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 18:52:27 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:15204 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZCGXw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 18:52:26 -0500
X-IronPort-AV: E=Sophos;i="4.38,321,1233532800"; 
   d="scan'208";a="152421011"
From: Roland Dreier <rdreier@cisco.com>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: printk issue - bug?
References: <8b67d60903071537p10994257obc7cce99028a740c@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 07 Mar 2009 15:52:23 -0800
In-Reply-To: <8b67d60903071537p10994257obc7cce99028a740c@mail.gmail.com>
	(Adrian McMenamin's message of "Sat, 7 Mar 2009 23:37:15 +0000")
Message-ID: <adaab7wgabs.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 Mar 2009 23:52:24.0102 (UTC) FILETIME=[C32E3C60:01C99F7F]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > printk("PAGE_SIZE is 0x%X\n", PAGE_SIZE);
 > printk("Offset is 0x%X, PAGE_SIZE is 0x%X, readlen is 0x%X\n", offset,
 > PAGE_SIZE, readlen)
 > 
 > Output is:
 > 
 > [  162.603348] PAGE_SIZE is 0x1000
 > [  162.607473] Offset is 0x0, PAGE_SIZE is 0x0, readlen is 0x1000
 > 
 > ie PAGE_SIZE is incorrectly reported in the second printk (these are
 > consecutive lines of code)
 > 
 > offset is loff_t and readlen is unsigned long.

ie offset is a 64-bit type but the printk format for it is %x, which
presumably only consumes 32 bits on SH4?  Seems like your code is buggy
and you ignored a compiler warning about printk format mismatch?

 - R.
