Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbYJ2FYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbYJ2FYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 01:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYJ2FYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 01:24:09 -0400
Received: from mail.suse.de ([195.135.220.2]:44561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYJ2FYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 01:24:08 -0400
Date: Tue, 28 Oct 2008 21:41:55 -0700
From: Brandon Philips <bphilips@suse.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dave Airlie <airlied@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, zhenyu.z.wang@intel.com,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-agp: Avoid oops for G33 on 1MB stolen case
Message-ID: <20081029044155.GA7834@plankton.ifup.org>
References: <20081014225817.GA29267@plankton.lan> <20081020142130.5c46bd7e.akpm@linux-foundation.org> <1224539086.3656.6.camel@optimus> <20081020145207.15843ca6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020145207.15843ca6@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:52 Mon 20 Oct 2008, Arjan van de Ven wrote:
> On Tue, 21 Oct 2008 07:44:46 +1000
> Dave Airlie <airlied@redhat.com> wrote:
> > > +				printk(KERN_WARNING PFX
> > > > +				       "Warning: G33 chipset
> > > > with 1MB"
> > > > +					" allocated. Older X.org
> > > > Intel drivers"
> > > > +					" will not work.\n");
> > > > +				WARN_ON(1);
> > > > +			}
> > > >  			gtt_entries = MB(1) - KB(size);
> > > >  			break;
> > > >  		case I855_GMCH_GMS_STOLEN_4M:
> > > 
> > > Is the bug which this patch addresses present in the 2.6.27 kernel?
> > > 
> > 
> > I've been a bit wary about this patch, but on re-review I suppose it
> > should be fine. We'll just get WARN_ONs in places we don't really want
> > them, and I'm sure Arjan will come complaining about them from
> > kerneloops.

I figured it was better to be noisy than to have people complaining
about X.org being broken.

Should it be something other than a WARN?

> the patch is not so nice for this;
> the printk+WARN_ON() really should be using WARN() instead; that also
> allows me to filter these guys out easily if needed.

Ok. I will send a new patch in a moment using WARN().

Thanks,

	Brandon
