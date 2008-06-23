Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYFWOEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYFWOEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYFWOEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:04:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:52247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYFWOEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:04:38 -0400
Date: Mon, 23 Jun 2008 07:04:35 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmap_min_addr/SECURITY_DEFAULT_MMAP_MIN_ADDR suggested values
Message-ID: <20080623070435.76c8b260@infradead.org>
In-Reply-To: <20080623135337.GE846@gallifrey>
References: <20080623135337.GE846@gallifrey>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.10; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 14:53:37 +0100
"Dr. David Alan Gilbert" <linux@treblig.org> wrote:

> Hi,
>   The config help for SECURITY_DEFAULT_MMAP_MIN_ADDR suggests 65536
> as a 'reasonable' value for x86 and the original mmap_min_addr
> patches suggested that 'something like 64k' was a safe value that
> wouldn't affect most programs.
> 
>   Where does this 64k value come from?  A number of distros seem
> to have followed this advice and have it set to 64k; but is there
> really any likely benefit of having it larger than PAGE_SIZE say?

there's a few things in the kernel that are bigger than 4K (or rather,
lead to pointers beyond 4K) so it's not all that bad advice.

> 
> I ask because I have an ancient program that maps stuff at 8k; the
> general advice of stuff on the net seems to be to set this limit
> to 0 if people have problems (I'm just lowering it to 4k),
> but I was thinking perhaps using a lower default value would be more
> secure since less people would take the easy answer and just turn the
> feature off altogether.

interesting... what does the program do?
(applications making assumptions on where they can mmap stuff... that's
not really valid. Realistically, the only safe way to use MAP_FIXED is
on memory that you got from mmap before.. think about it: what if
glibc happened to mmap something there first?)

So I'm quite curious what/why this app is doing this


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
