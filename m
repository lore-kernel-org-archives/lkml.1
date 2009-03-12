Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbZCLPu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbZCLPu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZCLPuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:50:14 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:43288 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbZCLPuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:50:12 -0400
Date: Thu, 12 Mar 2009 16:46:34 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Brice Goglin <Brice.Goglin@ens-lyon.org>
Cc: Matt Mackall <mpm@selenic.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>, akpm@linux-foundation.org
Subject: Re: [PATCH] acquire mmap semaphore in pagemap_read.
Message-ID: <20090312164634.6f2027ac@skybase>
In-Reply-To: <49B92D2B.2090100@ens-lyon.org>
References: <20090312113308.6fe18a93@skybase>
	<20090312114533.GA2407@x200.localdomain>
	<20090312125410.25400d18@skybase>
	<1236871414.3213.50.camel@calx>
	<20090312162733.4e8fd197@skybase>
	<49B92D2B.2090100@ens-lyon.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 16:41:31 +0100
Brice Goglin <Brice.Goglin@ens-lyon.org> wrote:

> > Which would be really ugly. I still have not grasped why this will
> > introduce a deadlock though. The worst the put_user can do is to cause
> > a page fault, no? I do not see where the fault handler acquires the
> > mmap_sem as writer. It takes the mmap_sem as reader and two readers
> > should be fine.
> 
> Somebody else can acquire for write in the meantime, for instance
> another thread doing mprotect. This writer is blocked by the first
> reader, and the second reader is blocked by the writer. So both
> tasks are blocked.

I see, fair r/w locks. So nested down_read is a no-no.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

