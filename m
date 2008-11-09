Return-Path: <linux-kernel-owner+w=401wt.eu-S1755171AbYKIM7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171AbYKIM7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 07:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYKIM7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 07:59:34 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56801 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYKIM7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 07:59:32 -0500
Message-ID: <4916DE5E.6070805@redhat.com>
Date: Sun, 09 Nov 2008 14:58:06 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Anthony Liguori <anthony@codemonkey.ws>, Matthew Wilcox <matthew@wil.cx>,
       H L <swdevyid@yahoo.com>, Yu Zhao <yu.zhao@intel.com>,
       randy.dunlap@oracle.com, grundler@parisc-linux.org, achiang@hp.com,
       linux-pci@vger.kernel.org, rdreier@cisco.com,
       linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       mingo@elte.hu, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com> <49137255.9010104@codemonkey.ws> <20081107061700.GD3860@kroah.com>
In-Reply-To: <20081107061700.GD3860@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> We've been talking about avoiding hardware passthrough entirely and
>> just backing a virtio-net backend driver by a dedicated VF in the
>> host.  That avoids a huge amount of guest-facing complexity, let's
>> migration Just Work, and should give the same level of performance.
>>     
>
> Does that involve this patch set?  Or a different type of interface.
>   

So long as the VF is exposed as a standalone PCI device, it's the same 
interface.  In fact you can take a random PCI card and expose it to a 
guest this way; it doesn't have to be SR-IOV.  Of course, with a 
standard PCI card you won't get much sharing (a quad port NIC will be 
good for four guests).

We'll need other changes in the network stack, but these are orthogonal 
to SR-IOV.

-- 
error compiling committee.c: too many arguments to function

