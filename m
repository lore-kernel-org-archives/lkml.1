Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZGBWZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZGBWZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZGBWZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:25:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:4471 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbZGBWZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:25:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,337,1243839600"; 
   d="scan'208";a="161090068"
Subject: Re: Memory leak in iwlwifi or false positive?
From: reinette chatre <reinette.chatre@intel.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1246570323.24044.16.camel@pc1117.cambridge.arm.com>
References: <1246570323.24044.16.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 15:25:33 -0700
Message-Id: <1246573533.17896.867.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Thu, 2009-07-02 at 14:32 -0700, Catalin Marinas wrote:
> Hi,
> 
> I'm trying to get kmemleak more robust and with the latest patches (not

I just compiled my 2.6.31 kernel with kmemleak but did not yet look into
how it works ... I do see a lot of messages though. 

> pushed yet) it seems to no longer show so many random leaks. However, I
> get a lot of leaks reported in the iwlwifi code, about 4800 and they do
> not disappear from any subsequent memory scanning (as is usually the
> case with false positives). There are a lot of kmalloc's of < 512 bytes
> and /proc/slabinfo seems to be in line with this:
> 
> kmalloc-512         5440   5481
> 
> This happens shortly after booting. Note that if an object is freed,
> kmemleak no longer tracks it and therefore no reporting. But in this
> case it looks like the iwlwifi code really allocated ~4800 blocks. Is it
> normal for this code to keep so many blocks allocated? If yes, it is
> probably kmemleak missing some root object in the references tree.

Yes - this sounds about right. You tested with 5100 hardware which by
default initializes 20 TX queues. For each of these queues it maintains
a 256 buffer array of commands with 356 bytes used for each command.

The 20 * 256 gives me 5120 ... would that explain the ~4800?

Reinette


