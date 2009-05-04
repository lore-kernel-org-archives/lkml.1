Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZEDIP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZEDIP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbZEDIOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:14:01 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:21175
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755051AbZEDIN5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:13:57 -0400
X-BigFish: VPS-23(zz1432R98dR148cM1805M936fJzz1202hzzz32i6bh15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ41IZ-04-JGA-01
Date: Mon, 4 May 2009 10:13:46 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Julia Lawall <julia@diku.dk>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: amd_iommu_init.c: possible problem with IVHD_FLAG_HT_TUN_EN
Message-ID: <20090504081345.GD6780@amd.com>
References: <Pine.LNX.4.64.0905021519390.9563@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0905021519390.9563@pc-004.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 04 May 2009 08:13:46.0207 (UTC) FILETIME=[3F0EEEF0:01C9CC90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 02, 2009 at 03:20:23PM +0200, Julia Lawall wrote:
> The file arch/x86/kernel/amd_iommu_init.c contains the following code:
> 
> (starting at line 586 in a recent linux-next)
> 
> 	h->flags & IVHD_FLAG_HT_TUN_EN ?
> 		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
> 		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
> 
> 	h->flags & IVHD_FLAG_PASSPW_EN ?
> 		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
> 		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
> 
> 	h->flags & IVHD_FLAG_RESPASSPW_EN ?
> 		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
> 		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
> 
> 	h->flags & IVHD_FLAG_ISOC_EN ?
> 		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
> 		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
> 
> The only possible value of IVHD_FLAG_HT_TUN_EN, however, seems to be 0, as
> defined in the same file, and thus the first test is never true.  Is this
> what is intended, or should the test be expressed in another way?

Very true. Another bug because I mixed up bit shifts with bit masks :-(
Thanks for reporting this. I will send a patch to fix it.

Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

