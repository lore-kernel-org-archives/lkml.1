Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbZCIQSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbZCIQSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZCIQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:18:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51254 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbZCIQSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:18:20 -0400
Message-ID: <49B54143.1010607@redhat.com>
Date: Mon, 09 Mar 2009 18:18:11 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-aio <linux-aio@kvack.org>, zach.brown@oracle.com, bcrl@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit
 to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer wrote:
> Hi,
>
> Believe it or not, I get numerous questions from customers about the
> suggested tuning value of aio-max-nr.  aio-max-nr limits the total
> number of io events that can be reserved, system wide, for aio
> completions.  Each time io_setup is called, a ring buffer is allocated
> that can hold nr_events I/O completions.  That ring buffer is then
> mapped into the process' address space, and the pages are pinned in
> memory.  So, the reason for this upper limit (I believe) is to keep a
> malicious user from pinning all of kernel memory.  Now, this sounds like
> a much better job for the memlock rlimit to me, hence the following
> patch.
>   

Is it not possible to get rid of the pinning entirely?  Pinning 
interferes with page migration which is important for NUMA, among other 
issues.

-- 
error compiling committee.c: too many arguments to function

