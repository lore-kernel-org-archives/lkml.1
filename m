Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZIHIme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZIHIme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754066AbZIHImd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:42:33 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:42684 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbZIHImd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:42:33 -0400
X-SourceIP: 213.93.53.227
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Anirban Sinha <ani@anirban.org>
Cc: Anirban Sinha <ASinha@zeugmasystems.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Dario Faggioli <raistlin@linux.it>
In-Reply-To: <9039A647-41AF-43C0-9376-F21E664F61E5@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net> <1252310374.7564.6.camel@twins>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC487@exchange.ZeugmaSystems.local>
	 <9039A647-41AF-43C0-9376-F21E664F61E5@anirban.org>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 10:42:27 +0200
Message-Id: <1252399347.7746.19.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 00:08 -0700, Anirban Sinha wrote:

> > Actually there is, use cpusets to carve the system into partitions.
> 
> hmm. ok. I looked at the code a little bit. It seems to me that the  
> 'borrowing' of RT runtimes occurs only from rt runqueues belonging to  
> the same root domain. And partition_sched_domains() is the only  
> external interface that can be used to create root domain out of a CPU  
> set. But then I think it needs to have CGROUPS/USER groups enabled?  
> Right?

No you need cpusets, you create a partition by disabling load-balancing
on the top set, thereby only allowing load-balancing withing the
children.

The runtime sharing is a form of load-balancing.

CONFIG_CPUSETS=y

Documentation/cgroups/cpusets.txt

