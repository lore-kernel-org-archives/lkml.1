Return-Path: <linux-kernel-owner+w=401wt.eu-S1756935AbZELWv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbZELWv4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 18:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753521AbZELWvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 18:51:44 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48850 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbZELWvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 18:51:43 -0400
Message-ID: <4A09FD81.8090805@linux.vnet.ibm.com>
Date: Tue, 12 May 2009 15:51:45 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] perf_counter: rework ioctl()s
References: <20090508165219.469818319@chello.nl> <20090508170028.837558214@chello.nl> <18951.32643.749495.538351@drongo.ozlabs.ibm.com> <4A086A89.6030905@linux.vnet.ibm.com> <18952.36878.942836.803265@cargo.ozlabs.ibm.com> <4A08A8C6.1090302@linux.vnet.ibm.com> <18953.5194.205862.75538@drongo.ozlabs.ibm.com> <4A09A09A.7030009@linux.vnet.ibm.com> <18953.62894.217593.865445@cargo.ozlabs.ibm.com>
In-Reply-To: <18953.62894.217593.865445@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Corey Ashford writes:
> 
>> Another hypothesis is that the old PAPI code would open, mmap, close, 
>> then reopen, and mmap again.  I wonder if because I wasn't munmap'ing 
>> before the close, that I got some strange behavior from the kernel. 
> 
> In general an mmap will keep a reference to the file it is mapping,
> which means that if you do an mmap on a fd and then close the fd, the
> file stays open until the region is munmapped.  So your old PAPI code
> would have ended up with more counters active than you expected, if
> you thought closing the fd would have destroyed the counter.
> 
> That is, you don't have to munmap before close, but you do have to do
> both close and munmap to destroy the counter.


That makes perfect sense.  I'll bet that's what the problem was.  I think this 
issue can be closed.  Thank you Paul M. and Peter Z. for looking into this.

- Corey

