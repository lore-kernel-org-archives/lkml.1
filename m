Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbYDDNo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbYDDNo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 09:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYDDNoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 09:44:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:11137 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbYDDNoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 09:44:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=KYnaLSfQiBVG5i8LvpsRWcyp+YTOsimJA4cAP1iNbdjV3sqJDn5vca+C/poakWN9WAC8LFyJwvwi5e4iqhsdnylpH4mclqBF+2jLwPX6w3TCCVsdjKryuW2a39e9ilgpPxfZvSyoFMeGrDuJ6ysFIcjxjcW7hXJllaRVTIoRMjY=
Message-ID: <47F630AE.7050801@gmail.com>
Date: Fri, 04 Apr 2008 15:44:14 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Christoph Lameter <clameter@sgi.com>,
       Daniel Walker <dwalker@mvista.com>, Andi Kleen <andi@firstfloor.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Josh Aune <luken@omner.org>,
       Pekka Paalanen <pq@iki.fi>
Subject: [ANNOUNCE] kmemcheck v7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I skipped the public announcements for versions 5 and 6, but here is 7 :)

General description: kmemcheck is a patch to the linux kernel that
detects use of uninitialized memory. It does this by trapping every
read and write to memory that was allocated dynamically (e.g. using
kmalloc()). If a memory address is read that has not previously been
written to, a message is printed to the kernel log.

Changes since v4 (rough list):
- SLUB parts were broken-out into its own file to avoid cluttering the main
   SLUB code.
- A rather lot of cleanups, including removing #ifdefs from arch code.
- Some preparation in anticipation of an x86_64 port.
- Make reporting safer by using a periodic timer to inspect the error queue.
- Fix hang due to page flags changing too early on free().
- Fix hang due to kprobes incompatibility.
- Allow CONFIG_SMP, but limit number of CPUs to 1 at run-time.
- Add kmemcheck=0|1 boot option.
- Add /proc/sys/kernel/kmemcheck for run-time enabling/disabling.


These patches apply to Linus's v2.6.25-rc8. The latest patchset can also be
found here: http://folk.uio.no/vegardno/linux/kmemcheck/

(I will try to submit this for inclusion in 2.6.26, and testing and feedback
is of course very welcome!)

I would like to thank the following people, who provided patches or helped
in various ways:

Ingo Molnar
Paul McKenney
Pekka Enberg
Pekka Paalanen
Peter Zijlstra
Randy Dunlap


Kind regards,
Vegard Nossum
