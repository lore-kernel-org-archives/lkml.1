Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYC1BJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYC1BJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 21:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbYC1BJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 21:09:20 -0400
Received: from zrnetservice.com ([209.133.52.163]:58076 "EHLO
	www.zrnetservice.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752469AbYC1BJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 21:09:20 -0400
X-Greylist: delayed 2279 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Mar 2008 21:09:20 EDT
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 4] [RFC] hotplug memory: minor updates
Message-Id: <patchbomb.1206664116@localhost>
Date: Thu, 27 Mar 2008 17:28:36 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here's a small set of patches for memory hotplug which I needed to get
the Xen balloon driver working.

1. add add_memory_resource(), which allow a caller to provide the
   resource structure for memory being added,
2. add warnings when you try to add non-section-aligned and sized memory
   since it has undesireable results when you do so, and
3. decrease the i386 PAE section size to 2^29 (=512MB), since 1G is a
   bit too large for virtual memory ballooning
(4. don't steal all memory in paravirt_disable_iospace)

Still unresolved is how to prevent the user from onlining balloon
memory via sysfs, since that will almost certainly cause the kernel to
crash.

Thanks,
	J


