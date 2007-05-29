Return-Path: <linux-kernel-owner+w=401wt.eu-S1752077AbXE2WfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbXE2WfG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXE2Wey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:34:54 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3028 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbXE2Wex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:34:53 -0400
Message-ID: <465CAA86.5020402@shadowen.org>
Date: Tue, 29 May 2007 23:34:46 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Steve Fox <drfickle@us.ibm.com>
Subject: Re: 2.6.22-rc1-mm1
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464ADA5D.8050405@shadowen.org> <464B2048.7040103@zytor.com> <20070516174046.GE10225@skynet.ie> <464B9573.8030407@zytor.com> <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0705171013560.27336@skynet.skynet.ie>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
> On Wed, 16 May 2007, H. Peter Anvin wrote:
> 
>> Correction, does *this patch* do it for you?
>>
> 
> With these two patches in combination, previously failing machines
> elm3b6 (x86_64 on test.kernel.org) and a modern x86 built a kernel and
> booted correctly.
> 
> elm3b132 and elm3b132 (x86 numaq on test.kernel.org) built with these
> patches but silently fail on boot with no output via earlyprintk.
> According to test.kernel.org, this failure occurs with git-newsetup
> reverted so it is a separate problem.

Ok, I've been following up on this failure on elm3b132/3.  I moved
forward to v2.6.22-rc2-mm1 and that also fails.  I ran a bisection on
the git-newsetup patch in as in -mm and basically it came down to the
first patch, ie. any and all of this tree stops the boot.

I just tried reproducing git-newsetup boot failures with the latest
version of your tree (369f16fdd423d79640c4390915e6ab71189cb497) and that
also fails.

Fails in this context is hard boot failure after loading the kernel and
before anything is printed.  I also added a printf to the top of main()
in boot/main.c and it doesn't come out, not that I really know if that
means it got there or not.

Any suggestions how to debug this puppy?

-apw
