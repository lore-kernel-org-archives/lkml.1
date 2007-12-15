Return-Path: <linux-kernel-owner+w=401wt.eu-S1757222AbXLODwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbXLODwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 22:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbXLODwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 22:52:43 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:46834 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbXLODwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 22:52:42 -0500
Date: Sat, 15 Dec 2007 09:22:00 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: htejun@gmail.com, gregkh@suse.de, stable@kernel.org,
       linux-kernel@vger.kernel.org, maneesh@linux.vnet.ibm.com,
       vatsa@linux.vnet.ibm.com, balbir@in.ibm.com, ego@in.ibm.com,
       linux-mm@kvack.org
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071215035200.GA22082@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071213162936.GA7635@suse.de> <20071213164658.GA30865@linux.vnet.ibm.com> <20071213175423.GA2977@linux.vnet.ibm.com> <476295FF.1040202@gmail.com> <20071214154711.GD23670@linux.vnet.ibm.com> <4762A721.7080400@gmail.com> <20071214161637.GA2687@linux.vnet.ibm.com> <20071214095023.b5327703.akpm@linux-foundation.org> <20071214182802.GC2576@linux.vnet.ibm.com> <20071214150533.aa30efd4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071214150533.aa30efd4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is it really the case that the bug only turns up when you run tests like
> 
> 	while echo; do cat /sys/kernel/kexec_crash_loaded; done
> and
> 	while echo; do cat /sys/kernel/uevent_seqnum ; done;
> 
> or will any fork-intensive workload also do it?  Say,
> 
> 	while echo ; do true ; done
> 

This does not leak, but having a simple text file and reading it in a
loop causes it.

> ?
> 
> Another interesting factoid here is that after the oomkilling you slabinfo has
> 
> mm_struct             38     98    584    7    1 : tunables   32   16    8 : slabdata     14     14      0 : globalstat    2781    196    49   31 				   0    1    0    0    0 : cpustat 368800  11864 368920  11721
> 
> so we aren't leaking mm_structs.  In fact we aren't leaking anything from
> slab.   But we are leaking pgds.
> 
> iirc the most recent change we've made in the pgd_t area is the quicklist
> management which went into 2.6.22-rc1.  You say the bug was present in
> 2.6.22.  Can you test 2.6.21?  

Nope, leak is not present in 2.6.21.7

-- 
regards,
Dhaval
