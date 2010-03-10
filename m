Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab0CJCvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 21:51:11 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:33542 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab0CJCvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 21:51:08 -0500
Subject: Re: Nick's vfs-scalability patches ported to 2.6.33-rt
From: john stultz <johnstul@us.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
In-Reply-To: <1267675511.4317.78.camel@localhost.localdomain>
References: <1267163608.2002.9.camel@work-vm> <20100226060109.GH9738@laptop>
	 <1267659090.4317.67.camel@localhost.localdomain>
	 <20100304033312.GO8653@laptop>
	 <1267675511.4317.78.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 18:51:02 -0800
Message-ID: <1268189462.3339.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-03 at 20:05 -0800, john stultz wrote:
> Thomas:  I ran a number of kernel-bench and dbench stress tests on this
> today and I've not seen any issues, so unless Nick has other issues, I
> think it should be ok to pull into -rt.
> 
> You can grab the full patchset that builds ontop of 2.6.33-rt4 here:
> http://sr71.net/~jstultz/dbench-scalability/patches/2.6.33-rt4/vfs-scale.33-rt.tar.bz2

Oh, and another interesting data point!

The ext2 performance numbers with this patch set are scaling better then
the 2.6.31-rt-vfs set earlier tested!

http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ext2-dbench.png

Its not perfect, but its closing the gap. More interestingly, where as
we were still seeing path lookup contention in 2.6.31, its not showing
up in the perf logs with 2.6.33. Instead, the contention is on the ext2
group_adjust_blocks function.

And replacing the statvfs call in dbench with statfs pushes the results
past mainline:
http://sr71.net/~jstultz/dbench-scalability/graphs/2.6.33/ext2-dbench-statfs.png


So this all means that with Nick's patch set, we're no longer getting
bogged down in the vfs (at least at 8-way) at all. All the contention is
in the actual filesystem (ext2 in group_adjust_blocks, and ext3 in the
journal and block allocation code).

So again, kudos to Nick!

thanks
-john

