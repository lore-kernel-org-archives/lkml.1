Return-Path: <linux-kernel-owner+w=401wt.eu-S1753403AbZL3Tuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbZL3Tuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 14:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZL3Tuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 14:50:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44001 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbZL3Tup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 14:50:45 -0500
Message-ID: <4B3BADDA.8040102@zytor.com>
Date: Wed, 30 Dec 2009 11:45:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       fche LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: record relocation offset
References: <4B3AC5CD.1000502@cn.fujitsu.com> <4B3AC629.4030504@cn.fujitsu.com> <20091230131518.GD2956@ghostprotocols.net>
In-Reply-To: <20091230131518.GD2956@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2009 05:15 AM, Arnaldo Carvalho de Melo wrote:
> 
> I'm no expert on the intricacies of boot_params, but all the other hunks
> seems sensible, but can't we provide a non-perf specific way of getting
> the relocate_offset? I guess other tools would also love to have it.
> 
> What about systemtap, don't they solve this in some other way? Frank?
> 

I at one point proposed that boot_params should be exported in toto via
sysfs.  This got rather brutally shut down as "it's just a debugging
feature" and got moved to debugfs (/debug/boot_params/data).  However,
the entire boot_params structure is available there.

Regardless of the reporting method, the patch passing this in by
modifying the early assembly code, though, is more than a little
pointless.  The kernel already knows where it is loaded -- obviously, by
sheer necessity -- and knows how it was itself configured, and as such
we can do this calculation in C code without modifying boot_params or
the early bootstrap.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

