Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbYFIWLX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbYFIWLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYFIWLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:11:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54511 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753317AbYFIWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:11:11 -0400
Date: Mon, 9 Jun 2008 17:11:06 -0500
From: Jack Steiner <steiner@sgi.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de, holt@sgi.com, andrea@qumranet.com
Subject: Re: [patch 09/11] GRU Driver - /proc interfaces
Message-ID: <20080609221105.GA20211@sgi.com>
References: <20080609211028.110089743@attica.americas.sgi.com> <20080609211046.935659965@attica.americas.sgi.com> <adaskvm70qp.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaskvm70qp.fsf@cisco.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 02:32:46PM -0700, Roland Dreier wrote:
>  > This file externalizes some GRU state & statistics to the user using the /proc
>  > file system.
> 
> We don't put stuff like this in /proc any more.  Depending on how the
> data will be used, either debugfs or a bunch of sysfs attributes would
> be typical ways to export it.

I was afraid of that. The data is not just for debugging. The info
must be available in standard production systems. So debugfs is not
appropriate.

Can you give me a pointer to a driver to use as a prototype
for /sys information.

 The GRU driver currently generates files that look like:

	
# cat /proc/gru/statistics
              11 vdata_free
              13 gts_alloc
              11 gts_free
              13 assign_context
              11 free_context
              13 load_context
              11 unload_context
              13 nopfn
              13 asid_new
               2 asid_next
             230 intr
              24 call_os
              13 set_task_slice
              38 migrate_check
             230 tlb_dropin
              12 tlb_dropin_fail_upm
             ....


# cat /proc/gru/gru_status
#  gid  nid    ctx   cbr   dsr     ctx   cbr   dsr
#             busy  busy  busy    free  free  free
     0    0      2     4  4096      14   124 28672
     1    0      1     2  1024      15   126 31744
     2    1      0     0     0      16   128 32768
     3    1      1     2  1024      15   126 31744
     ...


AFAICT, this is not a format that is compatible with the /sys guidelines of 1 value
per file.

A system can have 1000's of GRU chiplets. Having separate collection of files for
each set of metrics is clumsy. What other drivers have similar issues. I'll
gladly copy whatever makes sense.


--- jack
