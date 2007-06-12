Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbXFLDuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbXFLDuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbXFLDuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:50:44 -0400
Received: from holomorphy.com ([66.93.40.71]:47959 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbXFLDuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:50:44 -0400
Date: Mon, 11 Jun 2007 20:51:39 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Adam Litke <agl@us.ibm.com>
Cc: dean gaudet <dean@arctic.org>, "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, clameter@sgi.com
Subject: Re: [shm][hugetlb] Fix get_policy for stacked shared memory files
Message-ID: <20070612035139.GD6909@holomorphy.com>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org> <20070516061259.GZ19966@holomorphy.com> <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org> <1181597696.22671.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181597696.22671.2.camel@localhost.localdomain>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 04:34:54PM -0500, Adam Litke wrote:
> Here's another breakage as a result of shared memory stacked files :(
> The NUMA policy for a VMA is determined by checking the following (in
> the order given):
> 1) vma->vm_ops->get_policy() (if defined)
> 2) vma->vm_policy (if defined)
> 3) task->mempolicy (if defined)
> 4) Fall back to default_policy
> By switching to stacked files for shared memory, get_policy() is now
> always set to shm_get_policy which is a wrapper function.  This
> causes us to stop at step 1, which yields NULL for hugetlb instead of
> task->mempolicy which was the previous (and correct) result.
> This patch modifies the shm_get_policy() wrapper to maintain steps 1-3 for the
> wrapped vm_ops.  Andi and Christoph, does this look right to you?
> Signed-off-by: Adam Litke <agl@us.ibm.com>

Thanks for fielding this. The fix is certainly clear enough.

Acked-by: William Irwin <bill.irwin@oracle.com>


-- wli
