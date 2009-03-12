Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZCLP6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZCLP6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbZCLP6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:58:31 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50327 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZCLP6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:58:30 -0400
Date: Thu, 12 Mar 2009 16:54:51 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] acquire mmap semaphore in pagemap_read.
Message-ID: <20090312165451.1a7ef22f@skybase>
In-Reply-To: <1236871414.3213.50.camel@calx>
References: <20090312113308.6fe18a93@skybase>
	<20090312114533.GA2407@x200.localdomain>
	<20090312125410.25400d18@skybase>
	<1236871414.3213.50.camel@calx>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 10:23:34 -0500
Matt Mackall <mpm@selenic.com> wrote:

> Well it means we may have to reintroduce the very annoying double
> buffering from various earlier implementations. But let's leave this
> discussion until after we've figured out what to do about the walker
> code.

About the walker code. I've realized that there is another way to fix
this. The TASK_SIZE definition is currently used for two things: 1) as
a maximum mappable address, 2) the size of the address space for a
process. And there lies a problem: while a process is using a reduced
page table 1) and 2) differ. If I make TASK_SIZE give you the current
size of the address space then it is not possible to mmap an object
beyond 4TB and the page table upgrade never happens. If I make
TASK_SIZE return the maximum mappable address the page table walker
breaks. The solution could be to introduce MAX_TASK_SIZE and use that
in the mmap code to find out what can be mapped.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

