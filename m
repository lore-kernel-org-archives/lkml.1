Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbXFLDgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbXFLDgZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 23:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbXFLDgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 23:36:18 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:59427 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbXFLDgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 23:36:18 -0400
Date: Mon, 11 Jun 2007 20:36:17 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Adam Litke <agl@us.ibm.com>
cc: William Lee Irwin III <wli@holomorphy.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, clameter@sgi.com
Subject: Re: [shm][hugetlb] Fix get_policy for stacked shared memory files
In-Reply-To: <1181597696.22671.2.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706112035260.15086@twinlark.arctic.org>
References: <Pine.LNX.4.64.0705152222550.14691@twinlark.arctic.org> 
 <20070516061259.GZ19966@holomorphy.com>  <Pine.LNX.4.64.0706092106220.10324@twinlark.arctic.org>
 <1181597696.22671.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2007, Adam Litke wrote:

> Here's another breakage as a result of shared memory stacked files :(
> 
> The NUMA policy for a VMA is determined by checking the following (in the order
> given):
> 
> 1) vma->vm_ops->get_policy() (if defined)
> 2) vma->vm_policy (if defined)
> 3) task->mempolicy (if defined)
> 4) Fall back to default_policy
> 
> By switching to stacked files for shared memory, get_policy() is now always set
> to shm_get_policy which is a wrapper function.  This causes us to stop at step
> 1, which yields NULL for hugetlb instead of task->mempolicy which was the
> previous (and correct) result.
> 
> This patch modifies the shm_get_policy() wrapper to maintain steps 1-3 for the
> wrapped vm_ops.  Andi and Christoph, does this look right to you?

thanks for the patch -- seems to do the trick for me.  it seems like it 
would be a candidate for stable series as well.

-dean
