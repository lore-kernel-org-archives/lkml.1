Return-Path: <linux-kernel-owner+w=401wt.eu-S1757023AbZEDV4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023AbZEDV4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZEDV4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:56:07 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49363 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656AbZEDV4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:56:06 -0400
Message-ID: <49FF6474.7090000@linux.vnet.ibm.com>
Date: Mon, 04 May 2009 14:56:04 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: perf_counter: question about the user page data_head field
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In working on the PAPI substrate using the "Performance Counters for 
Linux" implementation (code that's currently in linux-2.6-tip, commit: 
c786fa3dc42e8e898cf1a33f9f5a25b61c7043f5), I encountered an issue with 
the data_head field.

I am implementing the profiling part of the substrate, and am using the 
mmap'd data pages to capture IP samples.  This is working quite well, 
and I've been able to profile on multiple events simultaneously.

However, one thing I ran into is when my code examines the data_head 
field from user space, it's always a multiple of the page size.  So it's 
apparently updated only on mmap page overflow.  I think I understand 
that this is done for efficiency reasons, but it's a limitation for the 
user space app in that they can miss up to 255 records (4096 byte pages 
/ 16-byte records), because the following mmap page is non empty but not 
full.

Perhaps I'm missing something.  Is there a way to force data_head to be 
updated from user space?  If not, I'd like to request that a new 
mechanism for doing such, perhaps via an ioctl call.

Thanks for your consideration,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
503-578-3507
cjashfor@us.ibm.com

