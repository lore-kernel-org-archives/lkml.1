Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbZD1Ffm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbZD1Ffm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbZD1Ffd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:35:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40119 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZD1Ffc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:35:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Elladan <elladan@eskimo.com>
Subject: Re: Swappiness vs. mmap() and interactive response
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090428044426.GA5035@eskimo.com>
References: <20090428044426.GA5035@eskimo.com>
Message-Id: <20090428143019.EBBF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 28 Apr 2009 14:35:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to linux-mm and Rik)


> Hi,
> 
> So, I just set up Ubuntu Jaunty (using Linux 2.6.28) on a quad core phenom box,
> and then I did the following (with XFS over LVM):
> 
> mv /500gig/of/data/on/disk/one /disk/two
> 
> This quickly caused the system to. grind.. to... a.... complete..... halt.
> Basically every UI operation, including the mouse in Xorg, started experiencing
> multiple second lag and delays.  This made the system essentially unusable --
> for example, just flipping to the window where the "mv" command was running
> took 10 seconds on more than one occasion.  Basically a "click and get coffee"
> interface.

I have some question and request.

1. please post your /proc/meminfo
2. Do above copy make tons swap-out? IOW your disk read much faster than write?
3. cache limitation of memcgroup solve this problem?
4. Which disk have your /bin and /usr/bin?



> 
> There was no particular kernel CPU load -- the SATA DMA seemed fine.
> 
> If I actively used the GUI, then the pieces I was using would work better, but
> they'd start experiencing astonishing latency again if I just let the UI sit
> for a little while.  From this, I diagnosed that the problem was probably
> related to the VM paging out my GUI.
> 
> Next, I set the following:
> 
> echo 0 > /proc/sys/vm/swappiness
> 
> ... hoping it would prevent paging out of the UI in favor of file data that's
> only used once.  It did appear to help to a small degree, but not much.  The
> system is still effectively unusable while a file copy is going on.
> 
> From this, I diagnosed that most likely, the kernel was paging out all my
> application file mmap() data (such as my executables and shared libraries) in
> favor of total garbage VM load from the file copy.
> 
> I don't know how to verify that this is true definitively.  Are there some
> magic numbers in /proc I can look at?  However, I did run latencytop, and it
> showed massive 2000+ msec latency in the page fault handler, as well as in
> various operations such as XFS read.  
> 
> Could this be something else?  There were some long delays in latencytop from
> various apps doing fsync as well, but it seems unlikely that this would destroy
> latency in Xorg, and again, latency improved whenever I touched an app, for
> that app.
> 
> Is there any way to fix this, short of rewriting the VM myself?  For example,
> is there some way I could convince this VM that pages with active mappings are
> valuable?
> 
> Thanks.



