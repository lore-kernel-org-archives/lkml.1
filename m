Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbZCXTEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbZCXTEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZCXTDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:03:52 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:53393 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901AbZCXTDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:03:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=V6uGbwseZL46eC1qdPPrRbRKFOAFpU6i0ci6w9I8WzudGkSN5bVrZjse2ojGNarXUJ
         necFEfQnvTUeZc64bcR+rDnYU+FDnI7nMGhCU4PzAIag7bANkf+l/iZgktpDuqEzIoH6
         gDJHm+BvdUshaJzkpgE4kPibxoX4vUw26zYbs=
Message-ID: <49C92E14.5060802@vflare.org>
Date: Wed, 25 Mar 2009 00:31:40 +0530
From: Nitin Gupta <nitingupta910@gmail.com>
Reply-To: ngupta@vflare.org
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] compressed in-memory swapping take3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Project home: http://code.google.com/p/compcache/

It allows creating a RAM based block device which acts as swap disk.
Pages swapped to this device are compressed and stored in memory itself.
This is a big win over swapping to slow hard-disk which are typically used
as swap disk. For flash, these suffer from wear-leveling issues when used
as swap disk - so again its helpful. For swapless systems, it allows more
apps to run.


* Changelog: take3 vs take2
xvmalloc changes:
  - Use kernel defined macros and constants in xvmalloc and remove
    equivalent defines for ALIGN, roundup etc.
  - Use kernel bitops (set_bit, clear_bit)
  - Moved it to drivers/block since its not clear if it has any other
    user.
ramzswap changes:
  - All instances of compcache renamed to ramzswap.
    Also renamed module to ramzswap
  - Renamed "backing_dev" parameter to "backing_swap"
  - Documentation changes to reflect above changes.
  - Remove "table index" from object header (4 bytes). This will be
    needed when memory defragmentation is implemented. So, avoid this
    (small) overhead for now.


* Changelog: take2 vs initial revision:
xvmalloc changes:
  - Use Linux kernel coding style for xvmalloc
  - Collapse all individual flag test/set/get to generic {test_set_get}_flag
  - Added BLOCK_NEXT() macro to reach next contiguous block
  - Other minor cleanups - no functional changes
compcache block device code:
  - compcache core changes due to change in xvmalloc interface names


Links to performance numbers, use cases can be found in original thread:
http://lkml.org/lkml/2009/3/17/116

Thanks to Christoph, Pekka and Andrew for feedback on previous revisions.

Thanks,
Nitin
