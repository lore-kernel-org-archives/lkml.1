Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbXHPV3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbXHPV3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 17:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752578AbXHPV3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 17:29:23 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56913 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751902AbXHPV3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 17:29:22 -0400
Date: Thu, 16 Aug 2007 14:29:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, torvalds@linux-foundation.org, pj@sgi.com
Subject: Re: [PATCH 00/23] per device dirty throttling -v9
In-Reply-To: <20070816074525.065850000@chello.nl>
Message-ID: <Pine.LNX.4.64.0708161424010.18861@schroedinger.engr.sgi.com>
References: <20070816074525.065850000@chello.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any way to make the global limits on which the dirty rate 
calculations are based cpuset specific?

A process is part of a cpuset and that cpuset has only a fraction of 
memory of the whole system. 

And only a fraction of that fraction can be dirtied. We do not currently 
enforce such limits which can cause the amount of dirty pages in 
cpusets to become excessively high. I have posted several patchsets that 
deal with that issue. See http://lkml.org/lkml/2007/1/16/5

It seems that limiting dirty pages in cpusets may be much easier to 
realize in the context of this patchset. The tracking of the dirty pages 
per node is not necessary if one would calculate the maximum amount of 
dirtyable pages in a cpuset and use that as a base, right?




