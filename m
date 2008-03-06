Return-Path: <linux-kernel-owner+w=401wt.eu-S934904AbYCFUyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934904AbYCFUyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935512AbYCFUx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:53:28 -0500
Received: from smtp.seznam.cz ([77.75.72.43]:43840 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S935485AbYCFUx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:53:27 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 15:53:26 EST
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Thu, 06 Mar 2008 21:46:42 +0100
MIME-Version: 1.0
Subject: Re: [newbie:] Bonnie++2 hangs recent 2.6 kernels? Bash keeps looping in waitpid(), eating 100% CPU
Message-ID: <47D06642.17385.A0316D83@Frantisek.Rysanek.post.cz>
In-reply-to: <46E96951.10344.29AE6546@localhost>
References: <46E96951.10344.29AE6546@localhost>
X-mailer: Pegasus Mail for Windows (4.41)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.32@12660
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 Sep 2007 at 16:46, Frantisek Rysanek wrote:
[...cut...]
> 1) the bash process that's waiting for Bonnie++2 to return, 
>    starts looping inside the last waitpid() call I believe, 
>    eating 100% CPU.
[...cut...]

Apologies for following up on this thread after half a year... :-)

Things haven't changed in 2.6.24.2.
Bonnie++2 still causes the same sort of havoc.
I have a further bit or two to report:

I've read in some LKML postings that the interaction between block 
device buffering, FS operations and memory management (allocation) 
are rather "stochastic" in some areas. That's what turned my 
attention to the tweakable parameters of the VM / memory management.

I've tried 
echo "2" >/proc/sys/vm/overcommit_memory
echo "0" >/proc/sys/vm/overcommit_ratio
echo "200000" >/proc/sys/vm/min_free_kbytes
(on a machine with 1 GB of RAM and very few user-space processes 
running).
This had little or no effect on the misbehavior invoked by Bonnie++2.

I've been running Bonnie against EXT3 for my disk stress testing 
purposes.
If I switch to ReiserFS 3, the problem goes away.

I really got the idea to try Reiser 3 by reading the Bonnie++2 docs, 
which say that the last tests in the batch, consisting e.g. of 
creating and deleting a massive number of directories, are the sort 
of a benchmark where ReiserFS shows its beauty.
I've also noticed that the misbehavior often occurs right after the 
point where Bonnie++2 reports "start'em" (or what's the precise 
wording is).

Anyway I'll post more if/when I discover something.
Thanks for your attention, and for tolerating my vague postings in 
this list :-)

Frank Rysanek

