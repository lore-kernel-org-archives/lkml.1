Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYFTSOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYFTSOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750999AbYFTSOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:14:14 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:59132 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750989AbYFTSOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:14:14 -0400
Subject: Is e820_setup_gap broken ??
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, yhlu.kernel@gmail.com
Content-Type: text/plain
Organization: VMware INC.
Date: Fri, 20 Jun 2008 11:14:11 -0700
Message-Id: <1213985651.31598.11.camel@promb-2n-dhcp368.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am looking at the e820_setup_gap function in tip/master tree.

For i386 if we don't find a big enough gap in e820 map, we keep the
gapstart value to "0x10000000". Don't print any warning messages for the
user that we were unable to find gap in the 32bit address range. 

Now this address 0x10000000 can actually be used by the system ram or
may have been reserved for some reason. Wouldn't the system break if the
PCI devices started using this gap in such a case ?

Also note that this is not just a problem with the tip/master tree in
the current mainline tree too we do similar stuff for i386 kernel. 

Thanks,
Alok

