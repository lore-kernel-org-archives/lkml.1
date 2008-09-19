Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYISMeo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYISMeo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 08:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYISMeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 08:34:36 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:65163 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbYISMeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 08:34:36 -0400
X-BigFish: VPS-51(z21eW5edJz1418M1432R98dR1411M1805M936fQ873fnzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7G09C-03-H4A-01
Date: Fri, 19 Sep 2008 14:34:26 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28
Message-ID: <20080919123426.GN24392@amd.com>
References: <20080919202344V.fujita.tomonori@lab.ntt.co.jp> <20080919204738G.fujita.tomonori@lab.ntt.co.jp> <20080919115259.GL24392@amd.com> <20080919212327Y.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080919212327Y.fujita.tomonori@lab.ntt.co.jp>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Sep 2008 12:34:26.0707 (UTC) FILETIME=[0DC09630:01C91A54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 09:24:18PM +0900, FUJITA Tomonori wrote:
> On Fri, 19 Sep 2008 13:52:59 +0200
> Joerg Roedel <joerg.roedel@amd.com> wrote:
> 
> > On Fri, Sep 19, 2008 at 08:47:54PM +0900, FUJITA Tomonori wrote:
> > > On Fri, 19 Sep 2008 20:23:50 +0900
> > > FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> > > 
> > > And you don't need to add 'fullflush' to the generic place too.
> > > 
> > > 'fullflush' will be supported with only GART and AMD IOMMU. So adding
> > > the description of it to both GART and AMD IOMMU should be fine.
> > > 
> > > 'fullflush' has the same meaning for both IOMMUs. That's nice
> > > consistency, I think.
> > 
> > Huh? The whole point of this patch was to have a common option between
> > IOMMUs to disable lazy IOTLB flushing. This was suggested by _you_ and
> > the only reason I wrote this patch.
> 
> You misunderstand what I meant. I'm sorry if my explanation is not
> clear.
> 
> 
> > After this patch we can change other IOMMU implementations with lazy
> > flushing to use that parameter too.
> 
> I'm not sure that Calgary wants to support such option. It always uses
> lazy flushing.
> 
> 
> What I don't like is that there is no consistency about the option
> name for lazy flushing. It doesn't mean that we move the option to the
> generic place.
> 
> Here's my first reply:
> 
> =
> Would it be nice to have consistency of IOMMU parameters?
> 
> VT-d also has the kernel-boot option for this lazy flushing trick
> though VT-d 'strict' option is more vague than 'unmap_flush'
> =
> 
> What I meant that using the option name 'strict' that VT-d uses for
> lazy flushing for AMD IOMMU would be better than introducing a new
> option name, "unmap_flush" for AMD IOMMU though I don't think that
> 'strict' is the good name.
> 
> 
> Seems 'fullflush' is better than 'strict'. So I think that it's better
> to use 'fullflush' for AMD IMMU rather introducing a new name,
> 'unmap_flush'. But again, it doesn't mean that 'fullflush' moves to
> the generic place.

Ok, so now we have fullflush, which makes sense for all x86 hardware
IOMMUs except maybe Calgary (from what I know about Calgary fullflush
can be implemented there only with a abyssal performance penalty nobody
is willing to pay). So it makes sense to have the option in the generic
place. But we can surely add a comment that it does not affect Calgary
to the kernel documentation (and change VT-d to use that parameter too).
But the AMD IOMMU update chain is not the right place for making big
changes to other IOMMUs.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

