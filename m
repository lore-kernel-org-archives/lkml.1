Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbYCLRNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbYCLRNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 13:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYCLRNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 13:13:08 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:40332 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbYCLRNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 13:13:06 -0400
Message-ID: <47D80F13.7040304@pobox.com>
Date: Wed, 12 Mar 2008 13:12:51 -0400
From: Mark Lord <mlord@pobox.com>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, mlord@pobox.com, kristen.c.accardi@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [regression] pciehp hang on hp ia64 rx6600
References: <20080312064755.GA31493@ldl.fc.hp.com>
In-Reply-To: <20080312064755.GA31493@ldl.fc.hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Chiang wrote:
> Hi Mark, Kristin,
> 
> On my hp ia64 rx6600, 'modprobe pciehp' causes lockups and a
> system hang on 2.6.25-rc4. My system often hangs when only pciehp
> is loaded and my console is sitting idle, but I can accelerate
> the hang 100% of the time by immediately doing a 'modprobe
> acpiphp' right afterwards.
> 
> I have bisected the hang down to this commit:
> 
> 0a3c33d77ff7ad5b988997536a8f09c49e35ad20 is first bad commit
> commit 0a3c33d77ff7ad5b988997536a8f09c49e35ad20
> Author: Mark Lord <lkml@rtr.ca>
> Date:   Wed Nov 28 15:11:28 2007 -0800
> 
>     PCIE: fix PCIe Hotplug so that it works with ExpressCard slots on Dell notebooks (and others?) in conjunction with modparam of pciehp_force=1.
..

In this case, the bisection is probably not perfect,
because that original patch had a couple of bugs that
were fixed by a subsequent follow-up patch.

It is all rather fuzzy right now, because this work was all completed
at the merge window for the *previous* kernel, but has now sat bit-rotting
for nearly 6 months since I last looked at it.

That said, I'm building the latest 2.6.25-rc* to retest with here,
and hopefully we can work this out without much more fuss.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
