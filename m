Return-Path: <linux-kernel-owner+w=401wt.eu-S1757283AbZEHDZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283AbZEHDZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754576AbZEHDYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 23:24:55 -0400
Received: from hera.cwi.nl ([192.16.191.8]:49155 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbZEHDYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 23:24:55 -0400
Date: Fri, 8 May 2009 05:23:20 +0200
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org
Subject: Re: madvise failure
Message-ID: <20090508032315.GA19186@ub>
References: <20090507121012.GA17048@ub> <20090508100745.6ef9fe3c.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508100745.6ef9fe3c.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 10:07:45AM +0900, KAMEZAWA Hiroyuki wrote:
> "Andries E. Brouwer" <Andries.Brouwer@cwi.nl> wrote:
> 
>> In an application something like
>> 	p = mmap(0, sz, PROT_READ, MAP_PRIVATE, fd, 0);
>> 	madvise(p, sz, MADV_SEQUENTIAL);
>> is done for a small number of files, each with a size of a few GB.
>> A single sequential pass is done over these files - essentially a merge.
>> 
>> On an old machine the madvise is useful, and decreases total time.

> With the same kernel (Ubuntu/2.6.27) ? old one ?

Both Ubuntu/2.6.27: 2.6.27-11-generic (new) vs 2.6.27-11-server (old)

>> But on a more recent machine, with more memory, the madvise makes
>> things worse. There, it seems better not to reveal to the kernel
>> that the data will be read sequentially.
>> 
>> Timing (six files of 4GB each, quadcore Intel Q9550, 16GB memory,
>> kernel 2.6.27 [Ubuntu], two other processes active):
>> with madvise, 7 runs: real time varying 9m10s - 37m29s,
>> without madvise, 6 runs: real time fairly constant 5m45s - 5m54s.

> Accessing each page one by one sequentially ?

Yes. Essentially a merge.

> or Sequential but (may) skip some pages in each access ?

No.

Andries

