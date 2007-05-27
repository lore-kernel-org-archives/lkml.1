Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbXE0KVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbXE0KVB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 06:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbXE0KUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 06:20:53 -0400
Received: from il.qumranet.com ([82.166.9.18]:42240 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbXE0KUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 06:20:53 -0400
Message-ID: <46595B7F.9030006@qumranet.com>
Date: Sun, 27 May 2007 13:20:47 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Shaohua Li <shaohua.li@intel.com>
CC: kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       lhcs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/7] KVM: Suspend and cpu hotplug fixes
References: <1180008615579-git-send-email-avi@qumranet.com> <1180055432.9919.3.camel@sli10-conroe.sh.intel.com> <46569E23.6010101@qumranet.com>
In-Reply-To: <46569E23.6010101@qumranet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> I estimate that that take_cpu_down will run for about a millisecond if
> there are a few hundred vcpus which have last run on the dying cpu (and
> that's an extreme case, which is not expected in normal operation).

I measured vmclear time on an uncached vmcs (which would be all except 
for a handful which are cached on the cpu core) at 144 cycles.  Assuming 
a couple of cache misses for walking the list and accessing the vmcs, 
we're at about 500 cycles per vcpu, or 250us @ 2GHz.  So worst case is 
significantly less than 1 ms.

Is this acceptable for take_cpu_down()?

-- 
error compiling committee.c: too many arguments to function

