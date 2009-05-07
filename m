Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbZEGSZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbZEGSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZEGSZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:25:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34224 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751123AbZEGSZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:25:44 -0400
Message-ID: <4A032771.6050703@redhat.com>
Date: Thu, 07 May 2009 21:24:49 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <20090506160712.GW3036@sequoia.sous-sol.org> <4A031471.7000406@novell.com> <4A0322F1.2000905@redhat.com> <4A032390.6030100@gmail.com> <4A032472.4030106@redhat.com> <4A03259B.3050500@gmail.com>
In-Reply-To: <4A03259B.3050500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> I guess technically mmio can just be a simple access of the page which
> would be problematic to trap locally without a PF.  However it seems
> that most mmio always passes through a ioread()/iowrite() call so this
> is perhaps the hook point.  If we set the stake in the ground that mmios
> that go through some other mechanism like PFs can just hit the "slow
> path" are an acceptable casualty, I think we can make that work.
>   

That's my thinking exactly.

Note we can cheat further.  kvm already has a "coalesced mmio" feature 
where side-effect-free mmios are collected in the kernel and passed to 
userspace only when some other significant event happens.  We could pass 
those addresses to the guest and let it queue those writes itself, 
avoiding the hypercall completely.

Though it's probably pointless: if the guest is paravirtualized enough 
to have the mmio hypercall, then it shouldn't be using e1000.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

