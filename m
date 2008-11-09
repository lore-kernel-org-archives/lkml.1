Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYKINEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYKINEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 08:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753150AbYKINEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 08:04:42 -0500
Received: from mx2.redhat.com ([66.187.237.31]:42127 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752654AbYKINEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:04:40 -0500
Message-ID: <4916DF99.6020107@redhat.com>
Date: Sun, 09 Nov 2008 15:03:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Greg KH <greg@kroah.com>,
       Matthew Wilcox <matthew@wil.cx>, H L <swdevyid@yahoo.com>,
       Yu Zhao <yu.zhao@intel.com>, randy.dunlap@oracle.com,
       grundler@parisc-linux.org, achiang@hp.com, linux-pci@vger.kernel.org,
       rdreier@cisco.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, mingo@elte.hu, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com> <49137255.9010104@codemonkey.ws> <20081109064147.GD7123@il.ibm.com>
In-Reply-To: <20081109064147.GD7123@il.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
>> We've been talking about avoiding hardware passthrough entirely and
>> just backing a virtio-net backend driver by a dedicated VF in the
>> host.  That avoids a huge amount of guest-facing complexity, let's
>> migration Just Work, and should give the same level of performance.
>>     
>
> I don't believe that it will, and every benchmark I've seen or have
> done so far shows a significant performance gap between virtio and
> direct assignment, even on 1G ethernet. I am willing however to
> reserve judgement until someone implements your suggestion and
> actually measures it, preferably on 10G ethernet.
>   

Right now virtio copies data, and has other inefficiencies.  With a 
dedicated VF, we can eliminate the copies.

CPU utilization and latency will be worse.  If we can limit the 
slowdowns to an acceptable amount, the simplicity and other advantages 
of VF-in-host may outweigh the performance degradation.

> No doubt device assignment---and SR-IOV in particular---are complex,
> but I hardly think ignoring it as you seem to propose is the right
> approach.

I agree.  We should hedge our bets and support both models.

-- 
error compiling committee.c: too many arguments to function

