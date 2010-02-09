Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0BIND7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 08:03:59 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:7187 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab0BIND5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 08:03:57 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Feb 2010 08:03:57 EST
X-IronPort-AV: E=Sophos;i="4.49,436,1262563200"; 
   d="scan'208";a="9383913"
Date: Tue, 9 Feb 2010 12:51:02 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 5/7] xen: Make event channel work with PV
 featured HVM
In-Reply-To: <1265616354-7384-6-git-send-email-sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1002091233110.11349@kaball-desktop>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com> <1265616354-7384-6-git-send-email-sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Feb 2010, Sheng Yang wrote:
> We mapped each IOAPIC pin to a VIRQ, so that we can deliver interrupt through
> these VIRQs.
> 
> We used X86_PLATFORM_IPI_VECTOR as the noficiation vector for hypervisor
> to notify guest about the event.
> 
> The Xen PV timer is used to provide guest a reliable timer.
> 
> The patch also enabled SMP support, then we can support IPI through evtchn as well.
> 
> Then we don't need IOAPIC/LAPIC...
> 

First of all I want to say that this series looks much better than the
previous one.

However I think there might still be some room for improvement:
wouldn't it make more sense to map vectors to event channels instead of
IOAPIC pins? This way it could work for MSI and passthrought devices
too. Also it would make sense to have a per-vector delivery option in
vlapic.c in xen: vlapic_set_irq should probably be the function that
decides how to inject the vector into the guest, either using the
classic emulated method or an event channel.
The decision should come from a matrix so that the guest might decide to
enable event channels on a per vector basis instead of having a single
global switch.
It seems to me that doing an intx to event channel translation in
hvm/irq.c is not the right thing in the right place.


