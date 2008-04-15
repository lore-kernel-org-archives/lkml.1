Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbYDOVPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbYDOVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 17:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbYDOVO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 17:14:59 -0400
Received: from saeurebad.de ([85.214.36.134]:40786 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943AbYDOVO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 17:14:58 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, ak@suse.de, clameter@sgi.com,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com,
       linux-kernel@vger.kernel.org
Subject: Re: + bootmem-node-setup-agnostic-free_bootmem.patch added to -mm tree
References: <200804150623.m3F6NInZ014509@imap1.linux-foundation.org>
	<20080415071120.GB15499@elte.hu> <87hce3i8mq.fsf@saeurebad.de>
	<86802c440804151157m5baab2efla7f35a8f98ac76b7@mail.gmail.com>
	<87mynuhp0o.fsf@saeurebad.de>
	<86802c440804151303k29295e9bp70c1046b8c9dca76@mail.gmail.com>
Date: Tue, 15 Apr 2008 23:14:38 +0200
In-Reply-To: <86802c440804151303k29295e9bp70c1046b8c9dca76@mail.gmail.com>
	(Yinghai Lu's message of "Tue, 15 Apr 2008 13:03:53 -0700")
Message-ID: <87ej96hlc1.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Yinghai Lu" <yhlu.kernel@gmail.com> writes:

>>  > 2. intel cross node box: node0: 0g-2g, 4g-6g, node1: 2g-4g, 6g-8g. i
>>  > don't think they have two bdata struct for every node.
>>
>>  How do the bdata structures represent this setup right now?  Are you
>>  sure that there is not a node descriptor for every contiguous region?
>
> http://lkml.org/lkml/2008/3/25/233
>
> Subject	[patch] srat, x86_64: Add support for nodes spanning other nodes
>
> For example, If the physical address layout on a two node system with 8 GB
> memory is something like:
> node 0: 0-2GB, 4-6GB
> node 1: 2-4GB, 6-8GB
>
> Current kernels fail to boot/detect this NUMA topology.
>
> ACPI SRAT tables can expose such a topology which needs to be supported.
>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

As I understood the code (more guessing than understanding), it breaks
down these physical nodes into contiguous logical memory blocks which
then get represented by having a node descriptor for each of them.  Can
you confirm that?

	Hannes
