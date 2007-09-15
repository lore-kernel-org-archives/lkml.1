Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbXIOCbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbXIOCbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 22:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932795AbXIOC3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 22:29:43 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:48694 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932749AbXIOC3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 22:29:40 -0400
Date: Sat, 15 Sep 2007 11:30:00 +1000
From: David Gibson <dwg@au1.ibm.com>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@osdl.org>, linuxppc-dev@ozlabs.org,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
       rtc-linux@googlegroups.com
Subject: Re: rtc-ds1742.c should use resource_size_t for base address
Message-ID: <20070915013000.GA25414@localhost.localdomain>
Mail-Followup-To: Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Andrew Morton <akpm@osdl.org>, linuxppc-dev@ozlabs.org,
	Atsushi Nemoto <anemo@mba.ocn.ne.jp>, linux-kernel@vger.kernel.org,
	rtc-linux@googlegroups.com
References: <20070914055427.GM481@localhost.localdomain> <20070914122037.65a08f48@weaponx.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914122037.65a08f48@weaponx.rchland.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 12:20:37PM -0500, Josh Boyer wrote:
> On Fri, 14 Sep 2007 15:54:27 +1000
> David Gibson <david@gibson.dropbear.id.au> wrote:
> 
> > Currently the rtc driver, rtc-ds1742.c uses an unsigned long to store
> > the base mmio address of the NVRAM/RTC.  This breaks on systems like
> > PowerPC 440, which is a 32-bit core with 36-bit physical addresses: IO
> > on the system, including the RTC, is typically above the 4GB point,
> > and cannot fit into an unsigned long.
> > 
> > This patch fixes the problem by replacing the unsigned long with a
> > resource_size_t.  Tested on Ebony (PPC440) (with additional patches to
> > instantiate the ds1742 platform device appropriately).
> 
> Where would those additional patches be? :)

Coming, they still need polish...

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
