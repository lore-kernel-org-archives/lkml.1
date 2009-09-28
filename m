Return-Path: <linux-kernel-owner+w=401wt.eu-S1752936AbZI1QxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936AbZI1QxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbZI1QxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:53:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:41847 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550AbZI1QxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:53:22 -0400
Message-ID: <4AC0E9F2.1020408@kernel.org>
Date: Tue, 29 Sep 2009 01:53:06 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tony Vroon <tony@linx.net>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] percpu: fix unit_map[] verification in pcpu_setup_first_chunk()
References: <4ABAC2F1.3020302@kernel.org> <1254055797.2756.1.camel@localhost> <4AC0E201.2020006@kernel.org> <alpine.DEB.1.10.0909281223510.16040@gentwo.org> <4AC0E5D8.6090707@kernel.org> <4AC0E6A3.4040500@kernel.org> <alpine.DEB.1.10.0909281239100.16040@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0909281239100.16040@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 28 Sep 2009 16:53:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 29 Sep 2009, Tejun Heo wrote:
> 
>> Christoph, can you please elaborate why nr_cpu_ids < NR_CPUS is
>> broken?
> 
> If its just an internal number that becomes larger than NR_CPUS then
> everything is fine.
> 
> But if a real cpu id (returned by smp_processor_id()) gets larger than
> NR_CPUS then we get into trouble with the parts of the kernel that index
> by cpu id.

It's a unit number.  Each cpu has exactly one unit number assigned to
it but there can be holes, so unit number can legally go over both
nr_cpu_ids and NR_CPUS, so yeap, it's just an internal number used
inside percpu allocator.

Tony, the original patch should be correct.  Please verify.

Thanks.

-- 
tejun
