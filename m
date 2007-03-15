Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbXCOTIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbXCOTIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbXCOTIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:08:42 -0400
Received: from smtp.osdl.org ([65.172.181.24]:36739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbXCOTIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:08:35 -0400
Date: Thu, 15 Mar 2007 11:07:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, nikita@clusterfs.com,
       leroy.vanlogchem@wldelft.nl
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
Message-Id: <20070315110745.af867b10.akpm@linux-foundation.org>
In-Reply-To: <45F7EDC6.5090303@hitachi.com>
References: <45F7EDC6.5090303@hitachi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 14 Mar 2007 21:42:46 +0900 Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com> wrote:
>
> ...
>
> 
> -Solution:
> 
> I consider that all of the dirty pages for the disk have been written
> back and that the disk is clean if a process cannot write 'write_chunk'
> pages in balance_dirty_pages().
> 
> To avoid using up the free memory with dirty pages by passing blocking,
> this patchset adds a new threshold named vm.dirty_limit_ratio to sysctl.
> 
> It modifies balance_dirty_pages() not to block when the amount of
> Dirty+Writeback is less than vm.dirty_limit_ratio percent of the memory.
> In the other cases, writers are throttled as current Linux does.
> 
> 
> In this patchset, vm.dirty_limit_ratio, instead of vm.dirty_ratio, is
> used as the clamping level of Dirty+Writeback. And, vm.dirty_ratio is
> used as the level at which a writers will itself start writeback of the
> dirty pages.

Might be a reasonable solution - let's see what Peter comes up with too.

Comments on the patch:

- Please don't VM_DIRTY_LIMIT_RATIO: just use CTL_UNNUMBERED and leave
  sysctl.h alone.

- The 40% default is already too high.  Let's set this new upper limit to
  40% and decrease he non-blocking ratio.

- Please update the procfs documentation in ./Docmentation/

- I wonder if dirty_limit_ratio is the best name we could choose. 
  vm_dirty_blocking_ratio, perhaps?  Dunno.

