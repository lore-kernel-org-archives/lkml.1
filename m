Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYIVO1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYIVO1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 10:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752024AbYIVO1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 10:27:30 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43744 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbYIVO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 10:27:29 -0400
X-BigFish: VPS-24(zz1432R98dR1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K7LPHB-04-21F-01
Date: Mon, 22 Sep 2008 16:27:13 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off"
Message-ID: <20080922142713.GA24392@amd.com>
References: <20080922223457W.fujita.tomonori@lab.ntt.co.jp> <20080922140749.GY24392@amd.com> <20080922231619X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080922231619X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 22 Sep 2008 14:27:13.0925 (UTC) FILETIME=[4E915B50:01C91CBF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 11:16:25PM +0900, FUJITA Tomonori wrote:
> On Mon, 22 Sep 2008 16:07:49 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Mon, Sep 22, 2008 at 10:35:08PM +0900, FUJITA Tomonori wrote:
> > > This is against tip/x86/iommu.
> > > 
> > > =
> > > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Subject: [PATCH] AMD IOMMU: revert "x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off"
> > > 
> > > This reverts:
> > > 
> > > commit 8b14518fadd9d5915827d86d5c10e602fedf042e
> > > Author: Joerg Roedel <joerg.roedel@amd.com>
> > > Date:   Thu Jul 3 19:35:09 2008 +0200
> > > 
> > >     x86, AMD IOMMU: honor iommu=off instead of amd_iommu=off
> > > 
> > >     This patch removes the amd_iommu=off kernel parameter and honors the generic
> > > 
> > >     iommu=off parameter for the same purpose.
> > > 
> > > 
> > > The above commit is wrong.
> > 
> > It isn't. The user normally don't care about the type of IOMMU in the
> > system. So disabling it with iommu=off is the right way. To achieve what
> > you want its better to add iommu=gart and iommu=amd to the option
> > parser. This will be consistent with Calgary and SWIOTLB too.
> 
> I'm not talking about what the best way to disable IOMMUs for
> users. I'm talking about how the current code works. It's a different
> topic. If you want to fix this, that's fine.
> 
> I just pointed out:
> 
> - You think that iommu=off and amd_iommu=off worked in the same way,
> but they didn't.
> 
> - This commit removed the useful feature.

Ok, let me explain it this way. Before there was an AMD IOMMU driver
the user had to pass iommu=off to disable iommu usage at all and
iommu=soft to just disable usage of hardware IOMMUs. Further you have
iommu=calgary to select the Calgary driver. With AMD IOMMU the
situation is not very different. You can have two different hardware
IOMMUs in the system: GART and AMD IOMMU. Passing iommu=off still
disables all hardware IOMMUs. Your patch doesn't change that too. But to
be consistent with whats already there, the best solution to achieve
what you want it implementing iommu=gart and iommu=amd to select which
hardware IOMMU in the system you want to use.

Joerg


-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

