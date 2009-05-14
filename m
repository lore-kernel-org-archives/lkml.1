Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbZENEmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbZENEmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 00:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbZENEmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 00:42:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:46812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbZENEmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 00:42:42 -0400
Subject: Re: [PATCH -tip] x86: amd_iommu_init.c use NULL pointer
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Joerg Roedel <joerg.roedel@amd.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <aa79d98a0905132000g18629ebx7f260eca03a810fc@mail.gmail.com>
References: <1242253628.3364.26.camel@localhost.localdomain>
	 <aa79d98a0905132000g18629ebx7f260eca03a810fc@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 10:07:02 +0530
Message-Id: <1242275822.4574.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 07:00 +0400, Cyrill Gorcunov wrote:
> On 5/14/09, Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> >
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/kernel/amd_iommu_init.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/amd_iommu_init.c
> > b/arch/x86/kernel/amd_iommu_init.c
> > index 8c0be09..f728b12 100644
> > --- a/arch/x86/kernel/amd_iommu_init.c
> > +++ b/arch/x86/kernel/amd_iommu_init.c
> > @@ -898,7 +898,7 @@ static int __init init_exclusion_range(struct
> > ivmd_header *m)
> >  /* called for unity map ACPI definition */
> >  static int __init init_unity_map_range(struct ivmd_header *m)
> >  {
> > -	struct unity_map_entry *e = 0;
> > +	struct unity_map_entry *e = NULL;
> >
> >  	e = kzalloc(sizeof(*e), GFP_KERNEL);
> >  	if (e == NULL)
> > --
> > 1.6.0.6
> >
> Hi Jaswinder,
> I believe you could get rid of such init completely. We do check 'e'
> after kzalloc anyway.

Thanks, here is another patch:

[PATCH -tip] x86: amd_iommu_init.c fix initialization issue

struct unity_map_entry *e = 0 which should be struct unity_map_entry *e = NULL

But we do not need to initialize e as kzalloc will take care of it.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8c0be09..1ca0383 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -898,7 +898,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
 /* called for unity map ACPI definition */
 static int __init init_unity_map_range(struct ivmd_header *m)
 {
-	struct unity_map_entry *e = 0;
+	struct unity_map_entry *e;
 
 	e = kzalloc(sizeof(*e), GFP_KERNEL);
 	if (e == NULL)
-- 
1.6.0.6



