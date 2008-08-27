Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYH0Wl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYH0Wl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 18:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYH0WlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 18:41:20 -0400
Received: from outbound-mail-108.bluehost.com ([69.89.22.8]:50943 "HELO
	outbound-mail-108.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753325AbYH0WlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 18:41:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=qWfvCjQLQm54cXYtW9dfz+/WGh5zT6tRH9V+Yc/ZgB5n3ManZgmFjQo6B3/Xqinc8MQTn5667dB2ETAT8l2D5S3Kui+W/9TRSj19AFTgfQAptz3ti0rFqQZHR/hmwrq0;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Date: Wed, 27 Aug 2008 15:41:10 -0700
User-Agent: KMail/1.9.9
Cc: "Ingo Molnar" <mingo@elte.hu>, "David Witbrodt" <dawitbro@sbcglobal.net>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <914225.91320.qm@web82104.mail.mud.yahoo.com> <20080825073125.GA27950@elte.hu> <86802c440808250100g15b056e0l359e83c6a8ee488b@mail.gmail.com>
In-Reply-To: <86802c440808250100g15b056e0l359e83c6a8ee488b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271541.11546.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 25, 2008 1:00 am Yinghai Lu wrote:
> On Mon, Aug 25, 2008 at 12:31 AM, Ingo Molnar <mingo@elte.hu> wrote:
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >> this one should work. please apply this one only.
> >>
> >> YH
> >>
> >> [PATCH] x86: check hpet with BAR v2
> >
> > great. I've cleaned it up a bit (see the final commit below) and queued
> > it up in tip/x86/urgent for some testing. But there are a few open
> > questions, and an Ack/feedback from Jesse/Linus would be nice as well:
> >
> > - the forced insertion and the embedded knowledge about iomem_resource
> >  and ioport_resource looks ugly to me.
> >
> > - we should also extend this to other platform resource types that we
> >  know about: ioapic address(es) might be a prime candidate. (local
> >  APICs are CPU entities and should never show up as PCI devices) The
> >  mmconfig range is already properly accounted for by the PCI code
> >  itself, right?
>
> please check v3
>
> > - plus a more highlevel approach would be nice as well i think - making
> >  sure that the hpet driver runs before any of the PCI code, and
> >  inserting a special "sticky" resource there which would keep any
> >  potential followup generic PCI resource that overlaps this resource
> >  untouched. (with a proper kernel warning emitted as well - such
> >  situations are likely BIOS bugs.)
>
> yes, can remove that late_initcall tricky code to insert resource for
> lapic and ioapic, and mmconfig etc.

I agree, a higher level way of dealing with resource reservation might be 
nice.  I'm hoping to polish up TJ's PCI allocation code 
(http://tjworld.net/wiki/Linux/PCIDynamicResourceAllocationManagement) for 
2.6.28; it may have some stuff that can help.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
