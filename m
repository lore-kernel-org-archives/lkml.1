Return-Path: <linux-kernel-owner+w=401wt.eu-S1752759AbYFTS0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbYFTS0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYFTSZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:25:54 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:48470 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbYFTSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:25:54 -0400
Subject: Re: Is e820_setup_gap broken ??
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
In-Reply-To: <1213985651.31598.11.camel@promb-2n-dhcp368.eng.vmware.com>
References: <1213985651.31598.11.camel@promb-2n-dhcp368.eng.vmware.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 20 Jun 2008 11:25:52 -0700
Message-Id: <1213986352.31598.16.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-20 at 11:14 -0700, Alok Kataria wrote:
> I am looking at the e820_setup_gap function in tip/master tree.
> 
> For i386 if we don't find a big enough gap in e820 map, we keep the
> gapstart value to "0x10000000". Don't print any warning messages for the
> user that we were unable to find gap in the 32bit address range. 
> 
> Now this address 0x10000000 can actually be used by the system ram or
> may have been reserved for some reason. Wouldn't the system break if the
> PCI devices started using this gap in such a case ?

Ok I take this back.
In the PCI code path when we actually use this gap start address for
allocating the resource...allocate_resource will shout about the memory
address being already in use. And the pci device won't be allocated
which is the right thing to do.


> Also note that this is not just a problem with the tip/master tree in
> the current mainline tree too we do similar stuff for i386 kernel. 
> 
> Thanks,
> Alok

