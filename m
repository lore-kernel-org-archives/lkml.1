Return-Path: <linux-kernel-owner+w=401wt.eu-S1763453AbYARSZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453AbYARSZK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbYARSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:24:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:40479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbYARSY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:24:58 -0500
Date: Fri, 18 Jan 2008 13:24:37 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <Yinghai.Lu@Sun.COM>, venkatesh.pallipadi@intel.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: fix typo PAT to X86_PAT
Message-ID: <20080118182437.GA10167@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
	venkatesh.pallipadi@intel.com, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080118123140.GI11044@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 01:31:40PM +0100, Ingo Molnar wrote:
 
 > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
 >
 > > > thanks. But, i think we should rather do the following: if X86_PAT
 > > > is eanbled then /proc/mtrr should be read-only. There's no problem
 > > > _looking_ at MTRR contents, as long as we do not try to modify them.
 > > > Hm?
 > >
 > > anyway
 > >
 > > depends on !PAT
 > >
 > > need to be removed.
 > >
 > > it seems when PAT is used, some code still touch MTRR.
 >
 > you mean modifies MTRRs? Which code is that? (besides the /proc/mtrr
 > userspace API)

This exclusion is going to be a real pain in the ass for distro kernels.
It's impossible for example to build a kernel that will now support
the MTRR-alike registers on the AMD K6/early Cyrix etc and also
support PAT.

Additionally, given people tend to update their kernels a lot more often
than they update to a whole new version of X, it means until userspace
has caught up, we can't ship a kernel with PAT supported, or else
X gets a lot slower due to the missing mtrr support.

	Dave

-- 
http://www.codemonkey.org.uk
