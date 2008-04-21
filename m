Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYDUVK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYDUVK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755998AbYDUVKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:10:47 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:3902 "EHLO
	outbound2-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751354AbYDUVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:10:46 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JZP1GB-02-7KC-01
Date: Mon, 21 Apr 2008 15:17:26 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, Mitch Bradley <wmb@firmworks.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: OLPC: only check for OFW signature on VSA-less Geodes
Message-ID: <20080421211726.GG7323@cosmic.amd.com>
References: <480C0582.9010509@firmworks.com> <86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com> <480C1286.3040307@firmworks.com> <20080421102417.6de71391@ephemeral> <1208793253.9212.507.camel@pmac.infradead.org> <20080421130320.38b5f505@ephemeral> <1208805491.9212.520.camel@pmac.infradead.org> <20080421154618.2ed4978f@ephemeral> <1208809517.9212.537.camel@pmac.infradead.org> <20080421170230.2db18632@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080421170230.2db18632@ephemeral>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-OriginalArrivalTime: 21 Apr 2008 21:10:00.0194 (UTC) FILETIME=[0F2BDE20:01C8A3F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/08 17:02 -0400, Andres Salomon wrote:
> On Mon, 21 Apr 2008 21:25:17 +0100
> David Woodhouse <dwmw2@infradead.org> wrote:
> 
> > On Mon, 2008-04-21 at 15:46 -0400, Andres Salomon wrote:
> > > Well, no, it wasn't already working; that's the reason this whole
> > > thread started.  It was crashing someone's machine.  That's why the OFW
> > > interface, as imperfect as it is, is an _improvement_.
> > 
> > You're proposing a new interface between bootloader and kernel as a
> > temporary hack just to work around that until we fix it properly?
> > 
> > That seems like overkill to me. I'd just go for is_geode() as you
> > suggested, and maybe PCI configuration tricks to detect the lack of VSA
> > so we can be _fairly_ sure it's OLPC before we poke at it?
> > 
> > Or why not try '!page_is_ram(0xffffffc0 >> PAGE_SHIFT)' if it's just to
> > avoid that particular warning? :)
> > 
> 
> 
> Okay, does anyone have a problem with this?
> 
>     
> 
> 
> 
> 
> The OFW sig check requires an ioremap that is dangerous on non-OLPC
> systems.  Long term, we should be getting the signature from the
> device tree (/openprom/model), but for right now just limit the
> check to only run on a subset of Geode (GX2/LX) systems.
> 
> Signed-off-by: Andres Salomon <dilinger@debian.org>

Acked-by: Jordan Crouse <jordan.crouse@amd.com>

> diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
> index 11670be..3e66722 100644
> --- a/arch/x86/kernel/olpc.c
> +++ b/arch/x86/kernel/olpc.c
> @@ -211,6 +211,10 @@ static int __init olpc_init(void)
>  {
>  	unsigned char *romsig;
>  
> +	/* The ioremap check is dangerous; limit what we run it on */
> +	if (!is_geode() || geode_has_vsa2())
> +		return 0;
> +
>  	spin_lock_init(&ec_lock);
>  
>  	romsig = ioremap(0xffffffc0, 16);
> -- 
> 1.5.4.4
> 
> 
> -- 
> Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
> 

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

