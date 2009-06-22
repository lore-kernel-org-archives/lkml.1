Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZFVL1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZFVL1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZFVL1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:27:09 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:50240 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbZFVL1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:27:08 -0400
Date: Mon, 22 Jun 2009 13:27:02 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       npiggin@suse.de, chris.mason@oracle.com, kurt.hackel@oracle.com,
       dave.mccracken@oracle.com, Avi Kivity <avi@redhat.com>, jeremy@goop.org,
       Rik van Riel <riel@redhat.com>, alan@lxorguk.ukuu.org.uk,
       Rusty Russell <rusty@rustcorp.com.au>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: Re: [RFC] transcendent memory for Linux
Message-ID: <20090622132702.6638d841@skybase>
In-Reply-To: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
References: <cd40cd91-66e9-469d-b079-3a899a3ccadb@default>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jun 2009 16:53:45 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> Tmem has some similarity to IBM's Collaborative Memory Management,
> but creates more of a partnership between the kernel and the
> "privileged entity" and is not very invasive.  Tmem may be
> applicable for KVM and containers; there is some disagreement on
> the extent of its value. Tmem is highly complementary to ballooning
> (aka page granularity hot plug) and memory deduplication (aka
> transparent content-based page sharing) but still has value
> when neither are present.

The basic idea seems to be that you reduce the amount of memory
available to the guest and as a compensation give the guest some
tmem, no? If that is the case then the effect of tmem is somewhat
comparable to the volatile page cache pages.

The big advantage of this approach is its simplicity, but there
are down sides as well:
1) You need to copy the data between the tmem pool and the page
cache. At least temporarily there are two copies of the same
page around. That increases the total amount of used memory.
2) The guest has a smaller memory size. Either the memory is
large enough for the working set size in which case tmem is
ineffective, or the working set does not fit which increases
the memory pressure and the cpu cycles spent in the mm code.
3) There is an additional turning knob, the size of the tmem pool
for the guest. I see the need for a clever algorithm to determine
the size for the different tmem pools.

Overall I would say its worthwhile to investigate the performance
impacts of the approach.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

