Return-Path: <linux-kernel-owner+w=401wt.eu-S1756052AbYEWNNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052AbYEWNNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbYEWNM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:12:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59476 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753449AbYEWNM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:12:57 -0400
Date: Fri, 23 May 2008 08:12:55 -0500
To: linux-kernel@vger.kernel.org
Subject: [RFC] use of /sys versus /proc
User-Agent: nail 11.25 7/29/05
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080523131255.C19831F0380@attica.americas.sgi.com>
From: cpw@sgi.com (Cliff Wickman)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I have a need to display TLB shootdown statistics.  (I'm working
on a patch to implement this on a new machine at SGI.)

I had planned to display these statistics through /proc
as in arch/ia64/sn/kernel/sn2/sn2_smp.c (/proc/sgi_sn/ptc_statistics).

However, considering the general move to reserve /proc for
process-related things, I thought the community might prefer the
interface to be in /sys.

But sysfs has an output buffer restriction of one page, which
is too restrictive for statistics from very large cpu counts.
We intend to display about 10 numbers per cpu.

Besides, the spirit of /sys according to the sysfs.txt documentation:
    "Attributes should be ... preferably with only one value
     per file. ... acceptable to express an array of values of the same type."
  [it also  warns:
    "... expressing multiple lines of data, ... is heavily frowned upon.
     Doing these things may get you publically humiliated and your code
     rewritten without notice."]

If I break up the statistics files per-cpu, or maybe ranges of
cpu's, it would create a potentially large number of files in /sys.

Or, I could stick with a single file in /proc.

What would you recommend?

Thanks.
-Cliff Wickman
