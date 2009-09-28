Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZI1QgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZI1QgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbZI1QgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:36:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:41281 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752003AbZI1QgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:36:00 -0400
Message-ID: <4AC0E5D8.6090707@kernel.org>
Date: Tue, 29 Sep 2009 01:35:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Tony Vroon <tony@linx.net>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] percpu: fix unit_map[] verification in pcpu_setup_first_chunk()
References: <4ABAC2F1.3020302@kernel.org> <1254055797.2756.1.camel@localhost> <4AC0E201.2020006@kernel.org> <alpine.DEB.1.10.0909281223510.16040@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0909281223510.16040@gentwo.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 28 Sep 2009 16:35:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 29 Sep 2009, Tejun Heo wrote:
> 
>> pcpu_setup_first_chunk() incorrectly used NR_CPUS as the impossible
>> unit number while unit number can equal and go over NR_CPUS with
>> sparse unit map.  This triggers BUG_ON() spuriously on machines which
>> have non-power-of-two number of cpus.  Use UINT_MAX instead.
> 
> Uhhh. Funky. The assumption nr_cpu_ids < NR_CPUS has been broken. Wonder
> what other effects that will have. In particular since the slab and page
> allocators have arrays indexed by the cpu number and those arrays are
> dimensioned for NR_CPUS.

Heh.. that's not what's broken.  unit# can legally go over NR_CPUS or
nr_cpu_ids as cpus can be sparsely mapped to units.  The problem is
that I didn't fix unit_map allocation.  Will update the patch.  Just a
sec.

-- 
tejun
