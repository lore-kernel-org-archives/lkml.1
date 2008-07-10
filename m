Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYGJMmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYGJMmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYGJMl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:41:59 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:9080 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940AbYGJMl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:41:59 -0400
X-BigFish: VPS-35(zz1432R98dR7efV1805Mzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3SJ9O-03-R8S-01
Date: Thu, 10 Jul 2008 14:41:47 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 16/34] AMD IOMMU: add kernel command line parameters for AMD IOMMU
Message-ID: <20080710124147.GL14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-17-git-send-email-joerg.roedel@amd.com> <86802c440807100004y539fab5evb83511cba7a373c2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <86802c440807100004y539fab5evb83511cba7a373c2@mail.gmail.com>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 12:41:47.0551 (UTC) FILETIME=[512FCAF0:01C8E28A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:04:17AM -0700, Yinghai Lu wrote:
> On Thu, Jun 26, 2008 at 12:27 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > This patch adds two parameters to the kernel command line to control behavior
> > of the AMD IOMMU.
> >
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > ---
> >  arch/x86/kernel/amd_iommu_init.c |   34 ++++++++++++++++++++++++++++++++++
> >  1 files changed, 34 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
> > index d7a75bf..ec6f13b 100644
> > --- a/arch/x86/kernel/amd_iommu_init.c
> > +++ b/arch/x86/kernel/amd_iommu_init.c
> > @@ -789,3 +789,37 @@ void __init amd_iommu_detect(void)
> >        }
> >  }
> >
> > +static int __init parse_amd_iommu_options(char *str)
> > +{
> > +       for (; *str; ++str) {
> > +               if (strcmp(str, "off") == 0)
> > +                       amd_iommu_disable = 1;
> > +               if (strcmp(str, "isolate") == 0)
> > +                       amd_iommu_isolate = 1;
> > +       }
> > +
> > +       return 1;
> > +}
> > +
> > +static int __init parse_amd_iommu_size_options(char *str)
> > +{
> > +       for (; *str; ++str) {
> > +               if (strcmp(str, "32M") == 0)
> > +                       amd_iommu_aperture_order = 25;
> > +               if (strcmp(str, "64M") == 0)
> > +                       amd_iommu_aperture_order = 26;
> > +               if (strcmp(str, "128M") == 0)
> > +                       amd_iommu_aperture_order = 27;
> > +               if (strcmp(str, "256M") == 0)
> > +                       amd_iommu_aperture_order = 28;
> > +               if (strcmp(str, "512M") == 0)
> > +                       amd_iommu_aperture_order = 29;
> > +               if (strcmp(str, "1G") == 0)
> > +                       amd_iommu_aperture_order = 30;
> > +       }
> 
> could use
> memparse(str, &str);
> 
> and weight...

Thanks for that hint. I wasn't aware of memparse.

Joerg

-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

