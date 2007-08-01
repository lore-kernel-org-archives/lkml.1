Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXHAO4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXHAO4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757905AbXHAO4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:56:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:37219 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbXHAO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:56:07 -0400
Date: Wed, 1 Aug 2007 17:56:07 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Hugh Dickins <hugh@veritas.com>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-pm@linux-foundation.org,
       Borislav Deianov <borislav@users.sourceforge.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: 2.6.21-rc1: T60 ACPI issues
Message-ID: <20070801145607.GB8480@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070801135820.GA8266@mellanox.co.il>
	<Pine.LNX.4.64.0708011516540.15447@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011516540.15447@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Hugh Dickins <hugh@veritas.com>:
> Subject: Re: 2.6.21-rc1: T60 ACPI issues
> 
> On Wed, 1 Aug 2007, Michael S. Tsirkin wrote:
> 
> > Hi!
> > ACPI appears to have been broken with 2.6.23-rc1 on my T60
> > Userspace from ubuntu dapper.
> 
> (Whereas I'm using a T43p with openSUSE 10.2.)
> 
> > 
> > 1. During boot, I see a lot of messages like this:
> > [   41.034204] acpi LNXSYSTM:00: uevent: unsupported action-string; this will be ignored in a future kernel version
> 
> (I've not seen those.)
> 
> > 
> > 2. Pressing Fn/F4 does not trigger suspend to ram
> >    This normally triigers ACPI event which triggers suspend to RAM on Ubuntu
> >    (echo mem > /sys/power/state works)
> 
> I'll bet this is your CONFIG_THINKPAD_ACPI_INPUT_ENABLED=y.
> I got the same, see my "THINKPAD_ACPI_INPUT_ENABLED seems regressive"
> mail to Henrique and lkml an hour ago.

This? http://lkml.org/lkml/2007/8/1/176


> > 
> > 3. After suspend to RAM, system wakes up but laptop's screen is blank,
> >    switching VTs etc does not help.
> >    External screen wakes up OK though.
> >    dmesg output from boot attached.
> 
> (I've not had that.)

Bingo.
sudo rmmod thinkpad_acpi cures both 2 and 3.
Thanks for pointing this out.

Henrique, if there's a patch to test, pls let me know.
Or maybe CONFIG_THINKPAD_ACPI_INPUT_ENABLED should be N by default.

-- 
MST
