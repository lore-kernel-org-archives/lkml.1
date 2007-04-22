Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbXDVCFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbXDVCFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 22:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbXDVCFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 22:05:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:58796 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbXDVCFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 22:05:37 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: 2.6.20.7 locking up hard on boot
Date: Sat, 21 Apr 2007 22:00:09 -0400
User-Agent: KMail/1.9.5
Cc: "Marcos Pinto" <markybob@gmail.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Greg KH" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Jan Beulich" <jbeulich@novell.com>, "Alan Cox" <alan@redhat.com>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com> <20070421103632.GC4016@stusta.de> <62eb359a0704210354t26164b39tc8a842cf598f1927@mail.gmail.com>
In-Reply-To: <62eb359a0704210354t26164b39tc8a842cf598f1927@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704212200.09728.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2007 06:54, Marcos Pinto wrote:
> It took me several hours, but I just got done combing things over with
> bisect as Greg requested.  This is what git spit out as the problem
> patch in the end:
> 
> 7639e962234c76031d1ddf436def7fd9602be560 is first bad commit
> commit 7639e962234c76031d1ddf436def7fd9602be560
> Author: Jan Beulich <jbeulich@novell.com>
> Date:   Tue Mar 13 14:04:11 2007 -0400
> 
>     adjust legacy IDE resource setting (v2)
> 
>     adjust legacy IDE resource setting (v2)
> 
>     The change to force legacy mode IDE channels' resources to fixed non-zero
>     values confuses (at least some versions of) X, because the values reported
>     by the kernel and those readable from PCI config space aren't consistent
>     anymore.  Therefore, this patch arranges for the respective BARs to also
>     get updated if possible.
> 
>     Signed-off-by: Jan Beulich <jbeulich@novell.com>
>     Acked-by: Alan Cox <alan@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>     Cc: Chuck Ebbert <cebbert@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> :040000 040000 d4ee6822208dc3e205bfc92fd30121e7894e63a9
> 5155044aa75f0d2671e7f5081f5b2999f24034bd M      drivers
> bisect run success
> 

Looks like others are seeing failures due to this patch also:
http://bugzilla.kernel.org/show_bug.cgi?id=7562

-Len

