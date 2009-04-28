Return-Path: <linux-kernel-owner+w=401wt.eu-S1761621AbZD1PFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761621AbZD1PFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 11:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZD1PFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 11:05:45 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:36963
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752116AbZD1PFp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 11:05:45 -0400
X-BigFish: VPS-1(zz4015Lzz1202hzzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KITGL5-02-1BU-01
Date: Tue, 28 Apr 2009 17:05:31 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       mingo@redhat.com, fujita.tomonori@lab.ntt.co.jp, airlied@linux.ie
Subject: IOMMU and graphics cards
Message-ID: <20090428150531.GZ17438@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 28 Apr 2009 15:05:32.0206 (UTC) FILETIME=[C680B4E0:01C9C812]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

as I have seen the VT-d code implements a workaround for broken graphics
card drivers. What it does, when enabled, is giving each grahics device
direct access to all physical memory. I really don't like to implement
this but a similar workaround for the AMD IOMMU seems to be necessary.
The biggest problem here is that this kind of workaround disables device
isolation for graphics cards. Device isolation is the main reason for
using an IOMMU in an unvirtualized environment. So if this workaround is
enabled it is as good as disable the IOMMU at all.
Thats why I think a kernel compile option for this workaround is not
sufficient. Distributors will probably enable this in their kernels
which also disables device isolation even if the user don't want to use
these broken drivers.
I think we should change that and provide a better way which allows to
enable this workaround only if it is required (and it should be
transparent to the user which IOMMU is built into the system).
We have several options to do this:

	* Implement a kernel command line option to enable/disable the
	  workaround (what should be default?)
	* Use the IOMMU-API and write a kernel module which creates a
	  direct mapped protection domain and assigns the graphics
	  cards to it (need to be done carefully to not break graphics 
	  drivers which do everything right and use the DMA-API)
	* Any other great idea?

So what do you (and all the others reading this :-) think? I would
prefer the way of implementing a module but there may also be reasons
against this. I would like this to be disussed before I implement the
workaround for the AMD IOMMU.

Thanks,

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

