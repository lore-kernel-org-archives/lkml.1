Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZJATKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZJATKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZJATKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:10:21 -0400
Received: from kroah.org ([198.145.64.141]:57810 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311AbZJATKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:10:21 -0400
Date: Thu, 1 Oct 2009 12:07:33 -0700
From: Greg KH <greg@kroah.com>
To: Nathaniel McCallum <nathaniel@natemccallum.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Exposing device ids and driver names
Message-ID: <20091001190733.GA27434@kroah.com>
References: <4AC4DB65.8070404@natemccallum.com>
 <20091001164249.GA2715@kroah.com>
 <4AC4E07E.8040707@natemccallum.com>
 <20091001180531.GA3199@kroah.com>
 <4AC4F67C.7010500@natemccallum.com>
 <20091001184021.GA26875@kroah.com>
 <4AC4FB77.2090600@natemccallum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC4FB77.2090600@natemccallum.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 02:56:55PM -0400, Nathaniel McCallum wrote:
> On 10/01/2009 02:40 PM, Greg KH wrote:
> > On Thu, Oct 01, 2009 at 02:35:40PM -0400, Nathaniel McCallum wrote:
> >> On 10/01/2009 02:05 PM, Greg KH wrote:
> >>> On Thu, Oct 01, 2009 at 01:01:50PM -0400, Nathaniel McCallum wrote:
> >>>> On 10/01/2009 12:42 PM, Greg KH wrote:
> >>>>> Why not just use the baseline kernel as a model for this.  Do a 'make
> >>>>> allmodconfig' and then extract the data and publish it that way.  No
> >>>>> kernel changes are needed, and then any distro can be easily matched up
> >>>>> by this based on what they are using.  That will save you time in
> >>>>> downloading zillions of distro releases, and provide a nice easy way to
> >>>>> show what the kernel.org releases support.
> >>>>
> >>>> Unfortunately, I would not be able to track changes to the kernel in
> >>>> this model.  Since this is one of my explicit goals (to make sure that
> >>>> distro kernel changes get upstream), I think a non-invasive kernel
> >>>> modification would be worth the effort.
> >>>
> >>> But this was an invasive modification, it added space to the kernel
> >>> images for no real benifit other than for your tracking tools.  That's
> >>> not going to fly unless you can find another good use for the change.
> >>
> >> Which is why I asked for advice for better options.  I would prefer a
> >> non-invasive modification.  I am hoping that someone more familiar with
> >> the layer would provide such a suggestion.
> >>
> >> One potential benefit for moving module info to ELF sections would be
> >> the ability to strip kernel modules.  As a test, I did this on a recent
> >> Fedora rawhide kernel I had lying around.  Stripping the modules results
> >> in a 43% decrease in size (82M to 47M).
> >
> > Did those modules have debugging symbols enabled?  That seems like a
> > large savings for just the module device tables.
> 
> It does not appear so (none of the debug sections are present).  But I 
> could be wrong.
> 
> Stripping the modules on the penultimate Fedora 11 kernel results in the 
> same drop in size.  I can't imagine why a release kernel would have 
> anything extra left in the modules (unless it is just by accident).

Are you sure things still work after stripping?  Stuff like systemtap
and other tools?

thanks,

greg k-h
