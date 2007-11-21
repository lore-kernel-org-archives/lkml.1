Return-Path: <linux-kernel-owner+w=401wt.eu-S932672AbXKUBYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672AbXKUBYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764929AbXKUBQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:16:16 -0500
Received: from relay1.sgi.com ([192.48.171.29]:48514 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763538AbXKUBQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:16:14 -0500
Date: Tue, 20 Nov 2007 17:16:11 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
In-Reply-To: <Pine.LNX.4.64.0711201607460.29220@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711201703570.29648@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de>
 <Pine.LNX.4.64.0711201228180.26745@schroedinger.engr.sgi.com>
 <200711202159.36377.ak@suse.de> <Pine.LNX.4.64.0711201325130.27539@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711201607460.29220@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

But one can subtract too... Hmmm... So the cpu area 0 could be put at
the beginning of the 2GB kernel area and then grow downwards from 
0xffffffff80000000. The cost in terms of code is one subtract
instruction for each per_cpu() or CPU_PTR()

The next thing doward from 0xffffffff80000000 is the vmemmap at 
0xffffe20000000000, so ~32TB. If we leave 16TB for the vmemmap
(a 16TB vmmemmap be able to map 2^(44 - 6 + 12) = 2^50 bytes 
more than currently supported by the processors)

then the remaining 16TB could be used to map 1GB per cpu for a 16k config. 
That is wildly overdoing it. Guess we could just do it with 1M anyways. 
Just to be safe we could do 128M. 128M x 16k = 2TB?

Would such a configuration be okay?

 

