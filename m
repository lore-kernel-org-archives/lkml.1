Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbYKGHsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbYKGHsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYKGHsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:48:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:50537 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYKGHr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:47:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,563,1220252400"; 
   d="scan'208";a="636597248"
Message-ID: <4913F2AA.90405@intel.com>
Date: Fri, 07 Nov 2008 15:47:54 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Leonid.Grossman@neterion.com
CC: Matthew Wilcox <matthew@wil.cx>, rusty@rustcorp.com.au,
       H L <swdevyid@yahoo.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       "grundler@parisc-linux.org" <grundler@parisc-linux.org>,
       "achiang@hp.com" <achiang@hp.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 0/16 v6] PCI: Linux kernel SR-IOV support
References: <20081106154351.GA30459@kroah.com> <894107.30288.qm@web45108.mail.sp1.yahoo.com> <20081106164919.GA4099@kroah.com> <20081106174741.GC11773@parisc-linux.org> <20081106175308.GA17027@kroah.com> <49137255.9010104@codemonkey.ws> <20081107061700.GD3860@kroah.com>
In-Reply-To: <20081107061700.GD3860@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Nov 06, 2008 at 04:40:21PM -0600, Anthony Liguori wrote:
>> Greg KH wrote:
>>> On Thu, Nov 06, 2008 at 10:47:41AM -0700, Matthew Wilcox wrote:
>>>   
>>>> I don't think we really know what the One True Usage model is for VF
>>>> devices.  Chris Wright has some ideas, I have some ideas and Yu Zhao has
>>>> some ideas.  I bet there's other people who have other ideas too.
>>>>     
>>> I'd love to hear those ideas.
>>>   
>> We've been talking about avoiding hardware passthrough entirely and
>> just backing a virtio-net backend driver by a dedicated VF in the
>> host.  That avoids a huge amount of guest-facing complexity, let's
>> migration Just Work, and should give the same level of performance.

This can be commonly used not only with VF -- devices that have multiple 
DMA queues (e.g., Intel VMDq, Neterion Xframe) and even traditional 
devices can also take the advantage of this.

CC Rusty Russel in case he has more comments.

> 
> Does that involve this patch set?  Or a different type of interface.

I think that is a different type of interface. We need to hook the DMA 
interface in the device driver to virtio-net backend so the hardware 
(normal device, VF, VMDq, etc.) can DMA data to/from the virtio-net backend.

Regards,
Yu
