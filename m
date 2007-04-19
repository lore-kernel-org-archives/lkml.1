Return-Path: <linux-kernel-owner+w=401wt.eu-S2993214AbXDSJMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993214AbXDSJMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993226AbXDSJMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:12:41 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:45919 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993211AbXDSJMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:12:40 -0400
Message-ID: <46273251.4000403@bull.net>
Date: Thu, 19 Apr 2007 11:11:45 +0200
From: Valerie Clement <valerie.clement@bull.net>
User-Agent: Thunderbird 1.5.0.4 (Windows/20060516)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
References: <462622F8.10107@bull.net> <20070418135709.b499e050.akpm@linux-foundation.org>
In-Reply-To: <20070418135709.b499e050.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/04/2007 11:15:10,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 19/04/2007 11:15:12,
	Serialize complete at 19/04/2007 11:15:12
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> It could be due to I/O scheduler changes.  Which one are you using?  CFQ?
> 
> Or it could be that there has been some changed behaviour at the VFS/pagecache
> layer: the VFS might be submitting little hunks of lots of files, rather than
> large hunks of few files.
> 
> Or it could be a block-layer thing: perhaps some driver change has caused
> us to be placing less data into the queue.  Which device driver is that machine
> using?
> 
> Being a simple soul, the first thing I'll try when I get near a test box
> will be
> 
> for i in $(seq 1 16)
> do
> 	time dd if=/dev/zero of=$i bs=1M count=1024 &
> done
> 

I tried first the test with dd, the results are similar to those of FFSB 
tests, about 15 percent of degradation between 2.6.20.7 and 2.6.21-rc7.

I'm using the CFQ I/O scheduler. I changed it to the "deadline" one and 
I don't have any more the problem, I've got similar throughput values 
with 2.6.20.7 and 2.6.21-rc7 kernels.
So can we conclude that it's due to the CFQ scheduler?

I also checked the device driver used, the revision number is the same 
in 2.6.20 and 2.6.21.

   Valérie

