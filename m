Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbZCEOiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbZCEOiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:38:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZCEOhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:37:51 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25996 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZCEOhu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:37:50 -0500
X-BigFish: VPS-36(zz1432R98dR936eQ1805M936fKzzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KG1FAI-01-DAY-01
Date: Thu, 5 Mar 2009 15:37:26 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: msr architecture debug code
Message-ID: <20090305143726.GC7347@alberich.amd.com>
References: <1236008575.3332.2.camel@localhost.localdomain> <20090302205437.GB14471@elte.hu> <20090305135444.GB7347@alberich.amd.com> <1236262346.2527.3.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1236262346.2527.3.camel@ht.satnam>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Mar 2009 14:37:33.0297 (UTC) FILETIME=[EB7D0610:01C99D9F]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 07:42:26PM +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-05 at 14:54 +0100, Andreas Herrmann wrote:
> 
> > All nice suggestions but why in-kernel?
> > 
> 
> In Kernel Space:
> 
> We can read/write MSRs and can change the bits and see it effect without
> writing any code.

Sorry, I can't (or maybe I don't like to) follow.

(BTW, you don't even need to write C-code. You can use a one-liner in perl
or python to seek and read any MSR using /dev/cpu/*/msr.)

> And we can also dump these value if something goes wrong in thats
> sections for kernel that's why I am also using printk.

Just some example how to do this today. (I've recently used this for
debugging.) Using a kernel with msr module loaded or built-in plus using
x86info/lsmsr and hpa's msr-tools.

# lsmsr MTRRfix -c 0
MTRRfix64K_00000     = 0x0606060606060606
MTRRfix16K_80000     = 0x0606060606060606
MTRRfix16K_A0000     = 0x0000000000000000
MTRRfix4K_C0000      = 0x0505050505050505
MTRRfix4K_C8000      = 0x0505050505050505
MTRRfix4K_D0000      = 0x0000000000000000
MTRRfix4K_D8000      = 0x0000000000000000
MTRRfix4K_E0000      = 0x0505050500000000
MTRRfix4K_E8000      = 0x0505050505050505
MTRRfix4K_F0000      = 0x0505050505050505
MTRRfix4K_F8000      = 0x0505050505050505
# lsmsr SYS_CFG
SYS_CFG              = 0x0000000000160600
# lsmsr SYS_CFG -l -V3
SYS_CFG             : 0xc0010010
  8-8:SetDirtyEnE
  9-9:SetDirtyEnS
  10-10:SetDirtyEnO
  16-16:ChxToDirtyDis
  17-17:SysUcLockEn
  18-18:MtrrFixDramEn
  19-19:MtrrFixDramModEn
  20-20:MtrrVarDramEn
  21-21:MtrrTom2En
  22-22:Tom2ForceMemTypeWB
# wrmsr -p 0 0xc0010010 0x00000000001e0600
# lsmsr SYS_CFG
SYS_CFG              = 0x00000000001e0600
# lsmsr MTRRfix -c 0
MTRRfix64K_00000     = 0x1e1e1e1e1e1e1e1e
MTRRfix16K_80000     = 0x1e1e1e1e1e1e1e1e
MTRRfix16K_A0000     = 0x0000000000000000
MTRRfix4K_C0000      = 0x1515151515151515
MTRRfix4K_C8000      = 0x1515151515151515
MTRRfix4K_D0000      = 0x0000000000000000
MTRRfix4K_D8000      = 0x0000000000000000
MTRRfix4K_E0000      = 0x1515151500000000
MTRRfix4K_E8000      = 0x1515151515151515
MTRRfix4K_F0000      = 0x1515151515151515
MTRRfix4K_F8000      = 0x1515151515151515


IMHO, there is no need to do this in-kernel.


Regards,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


