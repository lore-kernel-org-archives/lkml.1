Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXDBSCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXDBSCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965634AbXDBSCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:02:18 -0400
Received: from smtpout.mac.com ([17.250.248.178]:59636 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626AbXDBSCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:02:17 -0400
In-Reply-To: <200704021354.32636.gene.heskett@gmail.com>
References: <200704021030.29747.gene.heskett@gmail.com> <20070402173544.GA19343@deepthought> <200704021354.32636.gene.heskett@gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <8EF5AE61-FC1C-4BA2-BB8D-B55221D8846B@mac.com>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: mmap error?
Date: Mon, 2 Apr 2007 14:02:11 -0400
To: Gene Heskett <gene.heskett@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 02, 2007, at 13:54:28, Gene Heskett wrote:
> Ahh, thank you very much.  But I have 7.0, supposedly fixed,  
> sigh...  That did fix it, the dvd is burning as I type, again thanks.
>
> ???? Can I put this into rc.local so its global?  I guess I will  
> just for effects.  Or is there an option in a make xconfig to reset  
> this to a usable sized limit?, because I can see cups also having  
> problems since I have its render cache set for 127 megs, which  
> should also trigger this.

Well, that's not a limit on how much memory you can map, it's a limit  
on how many pages you can lock into memory (as in, cannot be swapped  
out or written back to disk and reused).  For low-latency  
applications (IE: cd burning) you need to have all memory mlocked so  
that you don't get a low-latency wakup and then promptly lose all  
latency guarantees by swapping madly, but something like CUPS doesn't  
have a problem because it doesn't use mlock() or mlockall().

Cheers,
Kyle Moffett

