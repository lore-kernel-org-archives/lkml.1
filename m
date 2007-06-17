Return-Path: <linux-kernel-owner+w=401wt.eu-S1760962AbXFQWg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962AbXFQWg7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 18:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755680AbXFQWgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 18:36:52 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:45623 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755022AbXFQWgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 18:36:52 -0400
Date: Mon, 18 Jun 2007 00:36:49 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070617223649.GA31587@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <1181721735.4418.10.camel@malory> <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617213355.GC3430@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 05:33:55PM -0400, Dave Jones wrote:
> intel-agp
> 
> Though by the looks of things, with the working kernel, you don't have
> it loaded (it's dependant upon the 'agpgart' module, which prints the
> "Detected" line that was missing).

You are wrong.

1)

I don't have any agpgart module at all, in any of the kernels that I compiled.

$ find /lib/modules -name 'agpgart.ko'
$ /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64 -name '*agp*.ko'
/lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/sis-agp.ko
/lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/intel-agp.ko
/lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/via-agp.ko

2)

$ strings /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/intel-agp.ko | grep 'agpgart: Detected an Intel'
<6>agpgart: Detected an Intel %s Chipset.

Hence, in the case that the kernel works, intel-agp is loaded
WITHOUT printing this Detected line - while when it doesn't work,
it is loaded while printing this line.

Perhaps my "solution" is to remove this module completely?
I don't seem to need it.

-- 
Carlo Wood <carlo@alinoe.com>
