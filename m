Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZDMCGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZDMCGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753791AbZDMCFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:05:51 -0400
Received: from mga14.intel.com ([143.182.124.37]:12672 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZDMCFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:05:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,178,1239001200"; 
   d="scan'208";a="130680440"
Subject: Re: [BISECTED] 20 ACPI interrupts per second on EEEPC 4G
From: Zhang Rui <rui.zhang@intel.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <49E20EBA.2090708@tuffmail.co.uk>
References: <49DF6835.9040501@tuffmail.co.uk> <49DFE345.3010109@gmail.com>
	 <49E05F83.2090500@tuffmail.co.uk>  <49E20EBA.2090708@tuffmail.co.uk>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 10:06:03 +0800
Message-Id: <1239588363.7661.211.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-12 at 23:54 +0800, Alan Jenkins wrote:
> Alan Jenkins wrote:
> > Alexey Starikovskiy wrote:
> >> Alan Jenkins wrote:
> >>> On latest git, powertop shows 20 ACPI interrupts per second. 
> >>> Previously, this was closer to 1 per second.  See attached output (a
> >>> vs b, "a" is from 2.6.29-rc8).
> >>>
> >>> This is from a pretty sparse KDE desktop.  Normally I run
> >>> gnome-power-manager, but I killed it to make sure that wasn't
> >>> causing any problems.
> >>>
> >
> >>> gpe18:   60975  enabled
> >>> gpe_all:   60975
> >>> sci:   60975
> >>>
> >>> which I presume means lots of EC interrupts.
> >>>
> >>> [    0.134068] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66,
> >>> data = 0x62
> >>>
> >
> >> This patch looks to be a suspect:
> >> 34ff4dbccccce54c83b1234d39b7ad9e548a75dd,
> >> Please check if reversing it helps
> >
> > No, I still get 20 ACPI interrupts per second.
> >
> > I tried without powertop, just in case that was provoking it, but it
> > still happens:
> >
> > alan@alan-eeepc:/sys/firmware/acpi/interrupts$ cat sci; sleep 5; cat sci
> >    2583
> >    2680
> 
> I did wonder whether this was due to thermal polling.  So look what I
> found with bisection :-).
> 
so the problem is gone if you revert this patch, right?

thanks,
rui
> 
> b1569e99c795bf83b4ddf41c4f1c42761ab7f75e is first bad commit
> commit b1569e99c795bf83b4ddf41c4f1c42761ab7f75e
> Author: Matthew Garrett <mjg59@srcf.ucam.org>
> Date:   Wed Dec 3 17:55:32 2008 +0000
> 
>     ACPI: move thermal trip handling to generic thermal layer
> 
>     The ACPI code currently carries its own thermal trip handling,
> meaning that
>     any other thermal implementation will need to reimplement it. Move
> the code
>     to the generic thermal layer.
> 
> 
> Regards
> Alan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

