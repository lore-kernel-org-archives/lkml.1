Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbYJTVwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbYJTVwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 17:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbYJTVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 17:52:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:58691 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYJTVw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 17:52:29 -0400
Date: Mon, 20 Oct 2008 14:52:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dave Airlie <airlied@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Brandon Philips <bphilips@suse.de>, zhenyu.z.wang@intel.com,
       jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-agp: Avoid oops for G33 on 1MB stolen case
Message-ID: <20081020145207.15843ca6@infradead.org>
In-Reply-To: <1224539086.3656.6.camel@optimus>
References: <20081014225817.GA29267@plankton.lan>
	<20081020142130.5c46bd7e.akpm@linux-foundation.org>
	<1224539086.3656.6.camel@optimus>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 07:44:46 +1000
Dave Airlie <airlied@redhat.com> wrote:
> > +				printk(KERN_WARNING PFX
> > > +				       "Warning: G33 chipset
> > > with 1MB"
> > > +					" allocated. Older X.org
> > > Intel drivers"
> > > +					" will not work.\n");
> > > +				WARN_ON(1);
> > > +			}
> > >  			gtt_entries = MB(1) - KB(size);
> > >  			break;
> > >  		case I855_GMCH_GMS_STOLEN_4M:
> > 
> > Is the bug which this patch addresses present in the 2.6.27 kernel?
> > 
> 
> I've been a bit wary about this patch, but on re-review I suppose it
> should be fine. We'll just get WARN_ONs in places we don't really want
> them, and I'm sure Arjan will come complaining about them from
> kerneloops.
> 

the patch is not so nice for this;
the printk+WARN_ON() really should be using WARN() instead; that also
allows me to filter these guys out easily if needed.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
