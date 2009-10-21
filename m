Return-Path: <linux-kernel-owner+w=401wt.eu-S1754817AbZJUTJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbZJUTJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZJUTJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbZJUTJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:09:49 -0400
Message-ID: <4ADF5C6B.80605@redhat.com>
Date: Wed, 21 Oct 2009 14:09:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Unnecessary overhead with stack protector.
References: <20091015183540.GA8098@redhat.com>	<20091015190720.GA19467@elte.hu>	<4ADF2DAA.9030604@redhat.com> <20091021110053.26ab9982@infradead.org> <4ADF59F8.7010205@redhat.com>
In-Reply-To: <4ADF59F8.7010205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Arjan van de Ven wrote:

...

>> do you have any indication that SP actually increases the stack
>> footprint by that much? it's only a few bytes....
>>
>>
> 
> Here's a sample of some of the largest xfs stack users,
> and the effect stack-protector had on them.  This was just
> done with objdump -d xfs.ko | scripts/checkstack.pl; I don't
> know if there's extra runtime stack overhead w/ stackprotector?
> 
> -Eric
> 
> function                  nostack stackprot delta delta %
> xfs_bmapi                      376      408    32  9%
> xfs_bulkstat                   328      344    16  5%
> _xfs_trans_commit              296      312    16  5%
> xfs_iomap_write_delay          264      280    16  6%
> xfs_file_ioctl                 248      312    64 26%
> xfs_symlink                    248      264    16  6%
> xfs_bunmapi                    232      280    48 21%
> xlog_do_recovery_pass          232      248    16  7%
> xfs_trans_unreserve_and_mod_sb 224      240    16  7%
> xfs_bmap_del_extent            216      248    32 15%
> xfs_cluster_write              216      232    16  7%
> xfs_file_compat_ioctl          216      296    80 37%
> xfs_attr_set_int               200      216    16  8%
> xfs_bmap_add_extent_delay_real 200      248    48 24%
> 

but maybe more to Dave's original point, xfs on x86_64 in my tree had
243 functions with minimal stack usage of 8 bytes.  w/
CC_STACKPROTECTOR_ALL in force, I end up with these sizes for those
functions:

  count bytes
      3 16
    236 24
      1 32
      5 40

8->24 bytes is pretty significant too, w/ a 200% increase, if you add a
few up...

-Eric
