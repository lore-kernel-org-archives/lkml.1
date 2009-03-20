Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZCTOIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZCTOIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZCTOIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:08:41 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:47201 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754133AbZCTOIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:08:40 -0400
Message-ID: <49C3A31D.6070208@vflare.org>
Date: Fri, 20 Mar 2009 19:37:25 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] compressed in-memory swapping take2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 090319-0, 19-03-2009), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It allows creating a RAM based block device which acts as swap disk.
Pages swapped to this device are compressed and stored in memory itself.
This is a big win over swapping to slow hard-disk which are typically used
as swap disk. For flash, these suffer from wear-leveling issues when used
as swap disk - so again its helpful. For swapless systems, it allows more
apps to run.

* Changelog: take2 vs initial revision:
xvmalloc changes:
  - Use Linux kernel coding sytle for xvmalloc
  - Collapse all individual flag test/set/get to generic {test_set_get}_flag
  - Added BLOCK_NEXT() macro to reach next contiguous block
  - Other minor cleanups - no functional changes
compcache block device code:
  - compcache core changes due to change in xvmalloc interface names

Links to performance numbers, use cases can be found in original thread:
http://lkml.org/lkml/2009/3/17/116

Thanks to Christoph and Pekka for feedback on initial revision.

Thanks,
Nitin
