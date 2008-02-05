Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbYBEU2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbYBEU2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758095AbYBEU2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:28:03 -0500
Received: from ns.suse.de ([195.135.220.2]:56718 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758496AbYBEU17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:27:59 -0500
From: Neil Brown <neilb@suse.de>
To: Robin Lee Powell <rlpowell@digitalkingdom.org>
Date: Wed, 6 Feb 2008 07:27:56 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18344.50892.5633.905311@notabene.brown>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: Re: Monthly md check == hung machine; how do I debug?
In-Reply-To: message from Robin Lee Powell on Tuesday February 5
References: <20080203212155.GF12173@digitalkingdom.org>
	<200802042140.55521.nickpiggin@yahoo.com.au>
	<20080205171005.GA9284@digitalkingdom.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday February 5, rlpowell@digitalkingdom.org wrote:
> 
> I was able to solve the problem, however, like so:
> 
> 132c133
> < # CONFIG_PREEMPT_NONE is not set
> ---
> > CONFIG_PREEMPT_NONE=y
> 134,135c135,136
> < CONFIG_PREEMPT=y
> < CONFIG_PREEMPT_BKL=y
> ---
> > # CONFIG_PREEMPT is not set
> > # CONFIG_PREEMPT_BKL is not set
> 

This suggests that there is some sort of race.
Given that I've never hit it on SMP machines, it is probably a very
small window that opens immediately after some event that triggers
kernel preemption.

The only "mdadm --monitor" does in the kernel is read /proc/mdstat and
maybe make some GET_ARRAY_INFO/ GET_DISK_INFO ioctl calls.

They don't do much more than grab the reconfig_mutex.....

What sort of hardware do you have?  x86?  SMP or uni-processor?
Also, exactly what kernel are you running?

I might see if I can reproduce it... so if you can send me the broken
.config, that might help too.

Thanks,
NeilBrown
