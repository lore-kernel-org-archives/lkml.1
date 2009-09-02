Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZIBBNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZIBBNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 21:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbZIBBNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 21:13:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53463 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbZIBBNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 21:13:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 2 Sep 2009 10:11:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Lasse =?UTF-8?B?S8Okcmtrw6RpbmVu?= <tronic+bpsk@trn.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Avoiding crash in out-of-memory situations
Message-Id: <20090902101157.89d23384.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A9D2079.3000805@trn.iki.fi>
References: <4A9D2079.3000805@trn.iki.fi>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Sep 2009 16:24:09 +0300
Lasse Kärkkäinen <tronic+bpsk@trn.iki.fi> wrote:

> Currently a number of simple while (1) malloc(n); processes can crash a 
> system even if resource limits are in place as one can only limit the 
> memory usage of a process (not that of an user nor the total used by the 
> userspace) and any otherwise reasonable nproc and memory limits can be 
> circumvented by using more processes.
> 
> The OOM killer is supposed to work as a fallback in these situations, 
> but unfortunately the system still goes absolutely unresponsive for 
> about 10 minutes whenever the OOM killer runs. It would seem that this 
> happens because the kernel first gets rid of all buffers and caches, 
> slowing things down to a halt, and the OOM killer activates only after 
> nothing else can be done.
> 
> In a more complex situation (e.g. the one that we just had on our server 
> by accidentally running too many valgrind processes) this hang state can 
> take very long, essentially requiring the server to be reseted the hard way.
> 
> As there AFAIK is no existing remedy to this problem, I would suggest 
> implementing either (a) per-user limits, (b) a memory reserve for the 
> kernel (e.g. one could reserve 100 MB for the kernel/buffers/caches, 
> giving less for the userspace to allocate even if that means having to 
> kill processes) or (c) both of them.
> 
> Or perhaps there is something that I missed?
> 
if per-user limit is allowed, memory cgroup ?

Documentation/cgroups/memory.txt

thx,
-Kame


> P.S. using or not using swap doesn't really affect the fundamental 
> problem nor its symptoms, so please don't suggest that either way.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

