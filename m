Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab0BDTru (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:47:50 -0500
Received: from www.tglx.de ([62.245.132.106]:51756 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932572Ab0BDTrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:47:49 -0500
Date: Thu, 4 Feb 2010 20:46:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] HPET: Drop WARN_ON for mismatch on HPET CMP readback
In-Reply-To: <1265312442.16916.588.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002042043140.3006@localhost.localdomain>
References: <20100204191112.GA10135@basil.fritz.box>  <1265311335.16916.586.camel@localhost.localdomain>  <20100204193224.GA8957@basil.fritz.box> <1265312442.16916.588.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Pallipadi, Venkatesh wrote:

> On Thu, 2010-02-04 at 11:32 -0800, Andi Kleen wrote:
> > On Thu, Feb 04, 2010 at 11:22:15AM -0800, Pallipadi, Venkatesh wrote:
> > > On Thu, 2010-02-04 at 11:11 -0800, Andi Kleen wrote:
> > > >  HPET: Drop WARN_ON for mismatch on HPET CMP readback
> > > >     
> > > >     At least one Intel chipset seems to always return a constant value
> > > >     when reading back the HPET CMP register. This triggers the WARN_ON_ONCE
> > > >     on each boot.
> > > 
> > > I don't know of chipset returning a constant value. Which chipset is
> > > this one?
> > 
> > Ibex Peak. That is I'm not sure it's fully constant, but at least
> > it's always the same value on the HPET read triggering on boot.
> 
> OK. Yes. Ibexpeak is the same problem as ICH9, with reads not returning
> the most recent write.

OTOH, none of the modern chipsets needs (hopefully) the read back to
avoid that missing interrupt issue which we saw on ATI.

So we could quite well do without the read back operation and save a
fair amount of cpu cycles that way. We can make it mandatory on those
ATI chips and have a command line option which helps us to debug
fallout or new problem cases.

Thanks,

	tglx
