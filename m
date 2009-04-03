Return-Path: <linux-kernel-owner+w=401wt.eu-S936561AbZDCWKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936561AbZDCWKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756980AbZDCWK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:10:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51437 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128AbZDCWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:10:26 -0400
Date: Fri, 3 Apr 2009 15:06:29 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D68431.30703@garzik.org>
Message-ID: <alpine.LFD.2.00.0904031452290.7007@localhost.localdomain>
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org> <alpine.LFD.2.00.0904031309500.4015@localhost.localdomain> <49D68431.30703@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Apr 2009, Jeff Garzik wrote:
>
> Since I am hacking on osdblk currently, I was too slack to code up a test.
> This is what bonnie++ says, at least...

Afaik, bonnie does it all in the page cache, and only tests random reads 
(in the "random seek" test), not random writes.

> But I guess seeks are not very helpful on an SSD :)  Any pre-built random
> write tests out there?

"fio" does well:

	http://git.kernel.dk/?p=fio.git;a=summary

and I think it comes with a few example files. Here's the random write 
file that Jens suggested, and that works pretty well..

It first creates a 2GB file to do the IO on, then does random 4k writes to 
it with O_DIRECT.

If your SSD does badly at it, you'll just want to kill it, but it shows 
you how many MB/s it's doing (or, in the sucky case, how many kB/s).

		Linus

---
[global]
filename=testfile
size=2g
create_fsync=1
overwrite=1

[randwrites]
# make rw= 'randread' for random reads, 'read' for reads, etc
rw=randwrite
bs=4k
direct=1

