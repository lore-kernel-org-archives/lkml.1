Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbXIXRcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbXIXRcJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 13:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755767AbXIXRb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 13:31:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43360 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755189AbXIXRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 13:31:55 -0400
Message-ID: <46F7F25B.6010706@sgi.com>
Date: Mon, 24 Sep 2007 10:22:35 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86: Convert cpuinfo_x86 array to a per_cpu array
 v2
References: <20070920213004.527735000@sgi.com>	<20070920213004.781159000@sgi.com> <20070921154622.c6920dcf.akpm@linux-foundation.org>
In-Reply-To: <20070921154622.c6920dcf.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 20 Sep 2007 14:30:05 -0700
> travis@sgi.com wrote:
> 
>> cpu_data is currently an array defined using NR_CPUS. This means that
>> we overallocate since we will rarely really use maximum configured cpus.
>> When NR_CPU count is raised to 4096 the size of cpu_data becomes
>> 3,145,728 bytes.
> 
> This has at least three quite obvious and careless compilation errors.
> 
> Please at least compile the code after you've altered it.
> 

Sorry for the build errors, my test build scripts obviously were missing
a critical kernel variant to test build.  I've fixed that omission and
increased the test build matrix significantly:

arch-i386-allmodconfig
arch-i386-allnoconfig
arch-i386-allyesconfig
arch-i386-defconfig
arch-i386-nomodconfig
arch-i386-nosmp
arch-i386-randconfig-1
arch-i386-randconfig-2
arch-i386-randconfig-3
arch-i386-randconfig-4
arch-i386-randconfig-5
arch-i386-smp
arch-x86_64-allmodconfig
arch-x86_64-allnoconfig
arch-x86_64-allyesconfig
arch-x86_64-nomodconfig
arch-x86_64-nosmp
arch-x86_64-randconfig-1
arch-x86_64-randconfig-2
arch-x86_64-randconfig-3
arch-x86_64-randconfig-4
arch-x86_64-randconfig-5
arch-x86_64-smp

A corrected patch follows.

Thanks,
Mike
