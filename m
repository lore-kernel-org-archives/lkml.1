Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbYCNDHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbYCNDHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 23:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYCNDG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 23:06:57 -0400
Received: from mga10.intel.com ([192.55.52.92]:38821 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750783AbYCNDG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 23:06:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,498,1199692800"; 
   d="scan'208";a="533686660"
Subject: Re: hackbench regression since 2.6.25-rc
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>
	 <20080313014808.f8d25c2a.akpm@linux-foundation.org>
	 <1205400538.3215.148.camel@ymzhang>
	 <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Mar 2008 11:04:02 +0800
Message-Id: <1205463842.3215.188.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-13 at 17:16 -0700, Christoph Lameter wrote:
> Could you recompile the kernel with slub performance statistics and post 
> the output of
> 
> slabinfo -AD
Before testing with kernel 2.6.25-rc5:
Name                   Objects    Alloc     Free   %Fast
vm_area_struct            2795   135185   132587  93  29
:0004096                    25   119045   119043  99  98
:0000064                 12257   119671   107742  98  50
:0000192                  3312    78563    75370  92  21
:0000128                  4648    48143    43738  97  53
dentry                   15217    46675    31527  95  72
:0000080                 12784    33674    21206  99  97
:0000016                  4367    25871    23705  99  78
:0000096                  3001    22591    20084  99  92
buffer_head               5536    18147    12884  97  42
anon_vma                  1729    14948    14130  99  73


After testing:
Name                   Objects    Alloc     Free   %Fast
:0000192                  3428 80093958 80090708  92   8
:0000512                   374 80016030 80015715  68   7
vm_area_struct            2875   224524   221868  94  20
:0000064                 12408   134273   122227  98  47
:0004096                    24   127397   127395  99  98
:0000128                  4596    57837    53432  97  48
dentry                   15659    51402    35824  95  64
:0000016                  4584    29327    27161  99  76
:0000080                 12784    33674    21206  99  97
:0000096                  2998    26264    23757  99  93


So block 192 and 512's and very active and their fast free percentage is low.

-yanmin


