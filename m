Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbXE3UN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbXE3UN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbXE3UNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:13:22 -0400
Received: from holomorphy.com ([66.93.40.71]:60330 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbXE3UNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:13:21 -0400
Date: Wed, 30 May 2007 13:13:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Nick Piggin <nickpiggin@yahoo.com.au>, ckrm-tech@lists.sourceforge.net,
       Balbir Singh <balbir@in.ibm.com>, efault@gmx.de,
       linux-kernel@vger.kernel.org, tingy@cs.umass.edu,
       Kirill Korotaev <dev@sw.ru>, kernel@kolivas.org, tong.n.li@intel.com,
       containers@lists.osdl.org, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: [ckrm-tech] [RFC] [PATCH 0/3] Add group fairness to CFS
Message-ID: <20070530201359.GD6909@holomorphy.com>
References: <4654BF88.3030404@yahoo.fr> <20070525074500.GD6157@in.ibm.com> <20070525082951.GA25280@elte.hu> <4656DF0C.9090306@sw.ru> <20070525153450.GA4679@in.ibm.com> <46570C70.4050209@sw.ru> <20070525180850.GA26884@in.ibm.com> <46577CA6.8000807@bigpond.net.au> <20070526154112.GA31925@holomorphy.com> <20070530171405.GA21062@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530171405.GA21062@in.ibm.com>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2007 at 08:41:12AM -0700, William Lee Irwin III wrote:
>> The smpnice affair is better phrased in terms of task weighting. It's
>> simple to honor nice in such an arrangement. First unravel the
>> grouping hierarchy, then weight by nice. This looks like
[...]
>> conveniently collapse to 1). Now that the hierarchy is flattened,
>> nice numbers can be factored in for t_1's final weight being
>> 0.7*0.36/(0.7*0.36+0.3*0.24+0.7*0.24+0.3*0.16) = 0.252/0.54 = 0.467..
>> and the others being 0.133.. (t_2), 0.311.. (t_3), and 0.0889.. (t_4).

On Wed, May 30, 2007 at 10:44:05PM +0530, Srivatsa Vaddagiri wrote:
> Hmm ..so do you think this weight decomposition can be used to flatten
> the tree all the way to a single level in case of cfs? That would mean we can 
> achieve group fairness with single level scheduling in cfs ..I am
> somewhat skeptical that we can achieve group fairness with a single
> level rb-tree (and w/o substantial changes to pick_next_task logic in cfs
> that is), but if it can be accomplished would definitely be a great win.

Yes, the hierarchy can be flattened completely and global task weights
computed and used to achieve group fairness. The changes aren't to
pick_next_task() but rather to the ->fair_key computations. In fact, I
went a step beyond that.


On Sat, May 26, 2007 at 08:41:12AM -0700, William Lee Irwin III wrote:
>> In such a manner nice numbers obey the principle of least surprise.

The step beyond was to show how nice numbers can be done with all that
hierarchical task grouping so they have global effects instead of
effects limited to the scope of the narrowest grouping hierarchy
containing the task. I had actually assumed the weighting and
flattening bits were already in your plans from some other post you
made and was building upon that.


-- wli
