Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYENQUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYENQUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 12:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbYENQUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 12:20:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45887 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYENQUY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 12:20:24 -0400
Date: Wed, 14 May 2008 09:20:15 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Message-ID: <20080514162015.GA6713@us.ibm.com>
References: <20080512205746.GB7401@us.ibm.com> <20080513210054.GB28815@us.ibm.com> <86802c440805131411w1e0c661j93ba1a1854f314d6@mail.gmail.com> <200805131528.18252.jbarnes@virtuousgeek.org> <86802c440805131623v4ecd038djeab9bd9937717de6@mail.gmail.com> <20080514000702.GA12546@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080514000702.GA12546@us.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 05:07:02PM -0700, Gary Hade wrote:
> On Tue, May 13, 2008 at 04:23:55PM -0700, Yinghai Lu wrote:
> > On Tue, May 13, 2008 at 3:28 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > > > >  There were some lkml/linux-pci visible discussions back in
> > >  > >  November-December of last year where I floated the idea
> > >  > >  of making PCI expansion ROM memory non-assignment the default:
> > >  > >   http://marc.info/?l=linux-kernel&m=119742188215024&w=2
> > >  > >   http://marc.info/?l=linux-kernel&m=119689499508369&w=2
> > >  > >  I did not hear any objections so I went ahead and submitted
> > >  > >  the change which entered mainline at 2.6.25-rc1 but it was
> > >  > >  sternly evicted last week because of a reported regression
> > >  > >  that it had caused:
> > >  > >   http://marc.info/?l=linux-kernel&m=121029093331908&w=2
> > >  > >  Attachments to http://bugs.freedesktop.org/show_bug.cgi?id=15523
> > >  > >  indicate that a 2.6.25-rc2 x86_64 kernel was being used.
> > >  > >
> > >  > >  > can we use pci rom in 64 bit kernel?
> > >  > >
> > >  > >  Sorry, not sure if I understand this question.  I hope the
> > >  > >  above answers it.
> > >  >
> > >  > ok, i think the driver could reload fw in the option rom to reset the
> > >  > controlller in pci card.
> > >  > i don't think there is other usage for the option rom after OS loaded,
> > >  > except option rom contain other run-time code...
> > >
> > >  On graphics devices it's used for more than just POSTing (in fact POSTing is
> > >  the least of its uses these days).  The ROM often contains tables describing
> > >  the specific hardware configuration of a given board, including output
> > >  information, extra supported modes, etc.
> > >
> > >  On other devices, it can be used to store default settings (this is common for
> > >  SCSI cards iirc, though I'm not sure how much Linux drivers use this info).
> > >
> > >
> > >  > so could disable them all, and use pci-quirks to enable that for the
> > >  > device/driver need it.
> > >
> > >  Since it's probably only big systems that really need the extra address space,
> > >  I'd rather to the opposite:  allocate ROM space by default and let a boot
> > >  option avoid it.
> > 
> > that boot option will get rid of that ROM BAR for all devices...
> > big system could use several graphical cards that need ROM BAR and
> > several cards that don't need ROM BAR.
> 
> Correct, not a perfect solution but better than we have right now.

...but don't let this comment make you think that I am not in
favor of something like you are suggesting.  I am interested
in getting the 'pci=norom' change into mainline quickly but it
is obviously less than ideal for the long term.

Jesse, any idea how many different devices absolutely need
memory allocated for their expansion ROMs?

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

