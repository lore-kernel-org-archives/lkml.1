Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbYG2PF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbYG2PF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 11:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYG2PFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 11:05:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:49426 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbYG2PFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 11:05:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GRV+IdB2tYpoqPrd755VVY3ZisCpnFy/3HxBSdD6f/B84RYKl5sc+TZHJIWBf7Rw6G
         BQSvSP7PARNDjDU9KbMQSk+OCHMhDLQf1XAU5fRQzN4FJxj1DSDPmWyIjsySC6GQNvGt
         Ecs6SQMXkVxV1KYOY0d+1+QcprMMfXmmnrhiw=
Date: Tue, 29 Jul 2008 19:05:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cpu4096 + smp_affinity breakage
Message-ID: <20080729150546.GA5140@martell.zuzino.mipt.ru>
References: <488F2A65.2090405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488F2A65.2090405@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 04:34:13PM +0200, Jiri Slaby wrote:
> I see cpu4096 branches in -tip. Do you know about /proc/irq/*/*smp_affinity 
> (irq_affinity_read_proc, default_affinity_read) breakage with NR_CPUS=4096? 
> Reading by `cat' from those files fails due to bitmap sent out is about 
> 1150 bytes, but cat provides only 1024B sized buffer. Can you think about 
> any fix for this?
>
> Using file offset and utilize only portion of that buffer returned to the 
> userspace will break atomicity I guess (does this matter?). If we get a 
> snapshot, it would get old if some reader breaks up. And if we use 
> per-reader buffer, we will be unable to free it. Any ideas?
>
> I think the same problem is for not-at-once-writes.

Time to ressurect my smp_affinity-as-seq-file patch which was dropped
for a stupid reason. 

