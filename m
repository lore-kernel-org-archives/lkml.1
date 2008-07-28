Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYG1Ikf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYG1Ikf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 04:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750736AbYG1Ik1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 04:40:27 -0400
Received: from ns.suse.de ([195.135.220.2]:58866 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbYG1Ik0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 04:40:26 -0400
Date: Mon, 28 Jul 2008 10:40:24 +0200
From: Karsten Keil <kkeil@suse.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org, kkeil@suse.de
Subject: Re: mISDN still breaking the allmodconfig build...
Message-ID: <20080728084024.GA23465@pingi.kke.suse.de>
References: <20080727.170235.97056809.davem@davemloft.net> <93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org> <20080727.180736.74131389.davem@davemloft.net> <7949EA87-4340-4353-AFC9-79A718B95DF0@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7949EA87-4340-4353-AFC9-79A718B95DF0@holtmann.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcel,
On Mon, Jul 28, 2008 at 03:13:21AM +0200, Marcel Holtmann wrote:
> Hi Dave,
> 
> >>>More fallout from the premature mISDN driver merge:
> >>>
> >>>drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not
> >>>running on big endian machines now"
> >>
> >>is that only the HFC driver or the whole mISDN stack?
> >>
> >>I know that the two old ISDN stacks where really bad on big endian,
> >>but my assumption was that we did sort this out in the end.
> >
> >One of the two mISDN drivers uses the deprecated virt_to_bus()
> >interface for handling DMA addresses (that doesn't even work on many
> >x86 systems these days) and the other mISDN driver gives the above
> >big-endian compile time error.
> >
> >In short, this driver was not ready for merging at all.
> 
> I am not defending it and agree that this driver should have had at  
> least one test run in linux-next.

Yes my fault, sorry.

> However mISDN is a whole ISDN stack.  
> So does mISDN has an issue too or do we only have a really broken  
> driver. Karsten?

Yes this is only a issue of the hardware layer not of the stack.

OK the driver are based on the old drivers already in HiSax and for
virt_to_bus() I never got a complain before and yes I already have some patches
to solve the endian issues in the HFC driver, but it was not finaly
confirmed, that all this work now on big endian systems and my PPC system
unfortunately died some time ago, so I did leave it as it is, but with
the wrong option, instead to mark it X86 only I let it break. 

On the other side this remained me to check the big endian thing again ;-)

-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
