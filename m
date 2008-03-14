Return-Path: <linux-kernel-owner+w=401wt.eu-S1755340AbYCNEfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbYCNEfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 00:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYCNEfD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 00:35:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbYCNEfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 00:35:01 -0400
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Mar 2008 15:34:48 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18394.104.595461.995367@notabene.brown>
Cc: mangoo@wpkg.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
       balajirrao@gmail.com
Subject: Re: sysfs Kernel BUG when RAID bitmap file has IO errors
In-Reply-To: message from Andrew Morton on Wednesday March 12
References: <47D7A502.6020701@wpkg.org>
	<47D7A7AA.8000302@wpkg.org>
	<20080312153618.b3e0612a.akpm@linux-foundation.org>
	<20080312154358.e9d16668.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday March 12, akpm@linux-foundation.org wrote:
> On Wed, 12 Mar 2008 15:36:18 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > I assume this is the BUG_ON(count >= (ssize_t)PAGE_SIZE) in
> > fill_read_buffer().

That's a new "BUG_ON".
Before commit 8118a859dc7abd873193986c77a8d9bdb877adc8
it was 
       BUG_ON(count > (ssize_t)PAGE_SIZE);

But I've been looking for an excuse to remove the "super" file from
sysfs for a while.
It doesn't really fit the sysfs model, and now clearly breaks it.  And
it isn't really all that useful (you can just read from the raw device
if you want to see the superblock.
It was a "seems like a good idea at the time" thing which I now
regret.

So:  I'll just remove it. (with apologies to anyone who actually uses
it, but I suspect there are only two of you :-)

Patch to follow

NeilBrown

