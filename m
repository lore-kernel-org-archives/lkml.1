Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZETQlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZETQlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 12:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbZETQle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 12:41:34 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:4956 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbZETQld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 12:41:33 -0400
X-BigFish: VPS-15(zz1432R98dR14ffO4015L1805Mzz1202hzz3198u327alz32i6bh6di43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJYBOP-02-PH6-01
Date: Wed, 20 May 2009 18:41:12 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: linux-next: Tree for May 20 (amd64_edac)
Message-ID: <20090520164112.GA29913@aftab>
References: <20090520170807.b75a9d86.sfr@canb.auug.org.au> <4A142CC9.4050904@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4A142CC9.4050904@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 20 May 2009 16:41:13.0777 (UTC) FILETIME=[C9D56A10:01C9D969]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 20, 2009 at 09:16:09AM -0700, Randy Dunlap wrote:
> Stephen Rothwell wrote:
> > Hi all,
> > 
> > Changes since 20090519:
> > 
> > Undropped tree:
> > 	edac-amd
> > 
> > The edac-amd tree lost its build failure.
> 
> 
> When K8_NB is not enabled:
> 
> drivers/built-in.o: In function `amd64_edac_init':
> amd64_edac.c:(.init.text+0x254f6): undefined reference to `cache_k8_northbridges'
> amd64_edac.c:(.init.text+0x25c38): undefined reference to `num_k8_northbridges'

ah, well, one dependency goes another one comes in :(. Thanks, will fix...

> Error with EDAC_AMD64 =y or =m.
> Error on both i386 and on x86_64.
> 
> 
> Comments on Kconfig for EDAC_AMD64:
> 
> config EDAC_AMD64
> 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
> 	depends on EDAC_MM_EDAC && X86 && PCI
> 	default m
> 	help
> 	Support for error detection and correction on the AMD 64
> 	Families of Memory Controllers (K8, F10h and F11h)
> 
> 
> Does this actually apply to X86_32 or should the depends be on
> X86_64 instead of X86?

and since K8_NB depends on X86_64, this answers that question :).
 
> The default y on EDAC_MM_EDAC and default m on EDAC_AMD64 should
> be removed.

The reasoning behind those comes from Ingo: people who enable EDAC
should get the modules automatically on instead of going through the
different entries in the subtree. Which sounds kind of reasonable, no?

See

http://marc.info/?l=linux-kernel&m=124173363813847

for details.

> The 2 lines of help text should be indented by 2 spaces.

ok, will do.

> Would be Good to have the amd64_edac maintainer(s) email addresses
> in MAINTAINERS file, please.

This is coming up.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

