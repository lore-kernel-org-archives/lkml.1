Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZEHPHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZEHPHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbZEHPHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:07:03 -0400
Received: from mail-qy0-f129.google.com ([209.85.221.129]:33388 "EHLO
	mail-qy0-f129.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZEHPG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:06:59 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2009 11:06:59 EDT
Message-ID: <4A0448DF.90705@codemonkey.ws>
Date: Fri, 08 May 2009 09:59:43 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <20090506072212.GV3036@sequoia.sous-sol.org> <4A018DF2.6010301@novell.com> <4A02D40D.7060307@redhat.com>
In-Reply-To: <4A02D40D.7060307@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> Hmm, reminds me of something I thought of a while back.
>
> We could implement an 'mmio hypercall' that does mmio reads/writes via 
> a hypercall instead of an mmio operation.  That will speed up mmio for 
> emulated devices (say, e1000).  It's easy to hook into Linux 
> (readl/writel), is pci-friendly, non-x86 friendly, etc.

By the time you get down to userspace for an emulated device, that 2us 
difference between mmio and hypercalls is simply not going to make a 
difference.  I'm surprised so much effort is going into this, is there 
any indication that this is even close to a bottleneck in any circumstance?

We have much, much lower hanging fruit to attack.  The basic fact that 
we still copy data multiple times in the networking drivers is clearly 
more significant than a few hundred nanoseconds that should occur less 
than once per packet.

Regards,

Anthony Liguori
