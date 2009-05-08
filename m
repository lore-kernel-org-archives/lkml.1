Return-Path: <linux-kernel-owner+w=401wt.eu-S1757863AbZEHBJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863AbZEHBJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 21:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZEHBJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 21:09:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50637 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083AbZEHBJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 21:09:17 -0400
Date: Fri, 8 May 2009 10:07:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: madvise failure
Message-Id: <20090508100745.6ef9fe3c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090507121012.GA17048@ub>
References: <20090507121012.GA17048@ub>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 14:10:17 +0200
"Andries E. Brouwer" <Andries.Brouwer@cwi.nl> wrote:

> In an application something like
> 	p = mmap(0, sz, PROT_READ, MAP_PRIVATE, fd, 0);
> 	madvise(p, sz, MADV_SEQUENTIAL);
> is done for a small number of files, each with a size of a few GB.
> A single sequential pass is done over these files - essentially a merge.
> 
> On an old machine the madvise is useful, and decreases total time.
With the same kernel (Ubuntu/2.6.27) ? old one ?

> But on a more recent machine, with more memory, the madvise makes
> things worse. There, it seems better not to reveal to the kernel
> that the data will be read sequentially.
> 
> Timing (six files of 4GB each, quadcore Intel Q9550, 16GB memory,
> kernel 2.6.27 [Ubuntu], two other processes active):
> with madvise, 7 runs: real time varying 9m10s - 37m29s,
> without madvise, 6 runs: real time fairly constant 5m45s - 5m54s.
> 
> 
Accessing each page one by one sequentially ? or 
Sequential but (may) skip some pages in each access ?

Thanks,
-Kame

