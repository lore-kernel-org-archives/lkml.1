Return-Path: <linux-kernel-owner+w=401wt.eu-S1751967AbXCHAqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbXCHAqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 19:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbXCHAqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 19:46:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52195 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbXCHAqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 19:46:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: [PATCH] swsusp: Disable nonboot CPUs before entering platform suspend
Date: Thu, 8 Mar 2007 01:48:35 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Shaohua Li <shaohua.li@intel.com>
References: <200703072044.12021.rjw@sisk.pl> <200703080013.05544.rjw@sisk.pl> <20070308002024.GF31910@redhat.com>
In-Reply-To: <20070308002024.GF31910@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703080148.35962.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 8 March 2007 01:20, Dave Jones wrote:
> On Thu, Mar 08, 2007 at 12:13:05AM +0100, Rafael J. Wysocki wrote:
> 
>  > > > Well, the WARN_ON() in arch/x86_64/kernel/acpi/sleep.c:init_low_mapping()
>  > > > triggers every time an SMP x86_64 box is suspended to disk using the platform
>  > > > mode (default), which is quite annoying IMHO and users think something wrong is
>  > > > going on.  This will probably cause them to report the problem and I'd rather
>  > > > like to avoid handling these reports. ;-)
>  > > 
>  > > Well sure - if patches were always error-free, we'd always apply them
>  > > immediately.
>  > > 
>  > > The question is: is the risk of this patch breaking things exceeded by the
>  > > benefit which you describe?
>  > 
>  > Well, it has survived some testing (http://lkml.org/lkml/2007/3/7/16).  Also,
>  > before the code ordering in 2.6.21-rc* we had been running on one CPU
>  > here, so I think the risk is small.
>  > 
>  > We could remove the WARN_ON() as Pavel has just suggested, but first I'd like
>  > to know who put it there and why.
> 
> It was introduced as part of ..
> 
> commit 55b2355eefc2f160246226d4d69fed431173a4d5
> Author: Shaohua Li <shaohua.li@intel.com>
> Date:   Fri Jun 23 02:04:49 2006 -0700
> 
>     [PATCH] don't use flush_tlb_all in suspend time
>     
>     flush_tlb_all uses on_each_cpu, which will disable/enable interrupt.
>     In suspend/resume time, this will make interrupt wrongly enabled.

Ah, thanks.

So the question is what can go wrong if we ignore the TLBs of the other
CPUs that may be on-line when init_low_mapping() is executed.

Frankly, I don't know.
