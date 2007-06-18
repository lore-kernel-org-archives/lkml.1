Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbXFRAGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbXFRAGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbXFRAGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:06:46 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:55017 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753715AbXFRAGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:06:45 -0400
Date: Mon, 18 Jun 2007 02:06:43 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
Message-ID: <20070618000643.GA1375@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
	eric@anholt.net, zhenyu.z.wang@intel.com
References: <20070613162925.GG3875@redhat.com> <20070614011506.GA30566@alinoe.com> <20070617162235.GA5486@alinoe.com> <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com> <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com> <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com> <20070617224918.GC12483@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070617224918.GC12483@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 06:49:18PM -0400, Dave Jones wrote:
> ok, then you must have CONFIG_AGP=y

I do - not voluntary however. For some mysterious reason I am
unable to set it to n or m. I am also not able to set CONFIG_AGP_INTEL
to n, only to y or m.
(using make 'menuconfig' for example).

>  > $ find /lib/modules -name 'agpgart.ko'
>  > $ /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64 -name '*agp*.ko'
>  > /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/sis-agp.ko
>  > /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/intel-agp.ko
>  > /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/via-agp.ko
>  > 
>  > 2)
>  > 
>  > $ strings /lib/modules/2.6.22-rc5-master-188e1f81ba31af1b65a2f3611df4c670b092bbac-amd64/kernel/drivers/char/agp/intel-agp.ko | grep 'agpgart: Detected an Intel'
>  > <6>agpgart: Detected an Intel %s Chipset.
>  > 
>  > Hence, in the case that the kernel works, intel-agp is loaded
>  > WITHOUT printing this Detected line
> 
> That doesn't make much sense.  The hardware doesn't change between
> a working & not-working kernel, and somehow the PCI probing fails.
> Hmm, do you have CONFIG_EDAC set ?

CONFIG_EDAC=m

$ lsmod | grep edac
$

> There's an outstanding bug (well, lack of feature) , where it claims
> the PCI device before AGP gets a chance to.
> This is unrelated to your hang however, but would at least explain
> the inconsistent probing.
> 
>  > Perhaps my "solution" is to remove this module completely?
>  > I don't seem to need it.
> 
> It's needed only for 3d,

Nope - I just played UT2004 without problems, and without intel-agp loaded.

> but it'd be good to figure out why its so
> broken on your system, even if you don't need it.

Please tell me what to do / try.
I'm an experienced coder - but I never really played with the
kernel before - so you'll have to spell out how to turn on debugging etc.

-- 
Carlo Wood <carlo@alinoe.com>
