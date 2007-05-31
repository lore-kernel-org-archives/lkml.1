Return-Path: <linux-kernel-owner+w=401wt.eu-S1758916AbXEaItE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916AbXEaItE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 04:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753668AbXEaIsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 04:48:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:39880 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbXEaIsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 04:48:54 -0400
Date: Thu, 31 May 2007 14:26:00 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       efault@gmx.de, linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Peter Williams <pwil3058@bigpond.net.au>, kernel@kolivas.org,
       tong.n.li@intel.com, containers@lists.osdl.org,
       Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070531085600.GA9826@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com> <20070530201359.GD6909@holomorphy.com> <20070531032657.GA823@in.ibm.com> <20070531040926.GH6909@holomorphy.com> <20070531054828.GB663@in.ibm.com> <20070531063647.GC15426@holomorphy.com> <20070531083353.GF663@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531083353.GF663@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 02:03:53PM +0530, Srivatsa Vaddagiri wrote:
> Its ->wait_runtime will drop less significantly, which lets it be
> inserted in rb-tree much to the left of those 1000 tasks (and which indirectly
> lets it gain back its fair share during subsequent schedule cycles).
> 
> Hmm ..is that the theory?

My only concern is the time needed to converge to this fair
distribution, especially in face of fluctuating workloads. For ex: a
container who does a fork bomb can have a very adverse impact on other
container's fair share under this scheme compared to other schemes which 
dedicate separate rb-trees for differnet containers (and which also support two 
level hierarchical scheduling inside the core scheduler).

I am inclined to have the core scheduler support atleast two levels of 
hierarchy (to better isolate each container) and resort to the flattening 
trick for higher levels.

-- 
Regards,
vatsa
