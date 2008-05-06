Return-Path: <linux-kernel-owner+w=401wt.eu-S932877AbYEFRqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932877AbYEFRqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 13:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763839AbYEFRqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 13:46:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760858AbYEFRq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 13:46:29 -0400
Date: Tue, 6 May 2008 10:45:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matthew Wilcox <matthew@wil.cx>, Ingo Molnar <mingo@elte.hu>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <20080506102153.5484c6ac.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805061044330.32269@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <20080506120934.GH19219@parisc-linux.org> <20080506162332.GI19219@parisc-linux.org> <20080506102153.5484c6ac.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 May 2008, Andrew Morton wrote:
> 
> down(), down_interruptible() and down_try() should use spin_lock_irq(), not
> irqsave.

down_trylock() is used in atomic code. See for example kernel/printk.c. So 
no, that one needs to be irqsafe.

		Linus
