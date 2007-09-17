Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbXIQSgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbXIQSgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbXIQSfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:35:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44998 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757433AbXIQSfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:35:10 -0400
Message-Id: <20070917183507.332345000@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 17 Sep 2007 11:35:07 -0700
From: travis@sgi.com
To: sfr@canb.auug.org.au, Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: [PATCH 0/1] ppc64: Convert cpu_sibling_map to a per_cpu data array ppc64 v2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stephen Rothwell wrote:
> On Mon, 17 Sep 2007 16:28:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> 	the topology (on my POWERPC5+ box) is not correct:
>>
>> cpu0/topology/thread_siblings:0000000f
>> cpu1/topology/thread_siblings:0000000f
>> cpu2/topology/thread_siblings:0000000f
>> cpu3/topology/thread_siblings:0000000f
>>
>> it used to be:
>>
>> cpu0/topology/thread_siblings:00000003
>> cpu1/topology/thread_siblings:00000003
>> cpu2/topology/thread_siblings:0000000c
>> cpu3/topology/thread_siblings:0000000c
> 
> This would be because we are setting up the cpu_sibling map before we
> call setup_per_cpu_areas().

The following patch hopefully should fix this problem.  I'm
not able to build or test it but the few references to 
cpu_sibling_map seem to all occur well after setup_per_cpu_areas
is called.

Thanks Stephen for checking this out!

-- 
