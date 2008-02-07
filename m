Return-Path: <linux-kernel-owner+w=401wt.eu-S1756201AbYBGIuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201AbYBGIuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 03:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754750AbYBGIui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 03:50:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:13080 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYBGIuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 03:50:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RPUDcQWnnINtO4IBpvex9B03OBgAEYdVjFEIvi3rb6ATs6vjjBqYIyT6hkaPugjrRGcDHn/OsWHbXYv8gIHOfMKMmWM8Sndb7QS+F1Ne5ZTfh2VOfyEqJAUzxBQ63Czhs7dZ2VSUci2wpDcbnQDJF3rzrSsq4P6UecUu+8ENJuc=
Message-ID: <86802c440802070050t2566a261t50cccd649912a4a9@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:50:35 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Balaji Rao" <balajirrao@gmail.com>
Subject: Re: [PATCH][Regression] x86, 32-bit: trim memory not covered by wb mtrrs - FIX
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>, jesse.barnes@intel.com,
       ak@suse.de
In-Reply-To: <200802071351.02763.balajirrao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802071257.51893.balajirrao@gmail.com>
	 <20080207080245.GA28631@elte.hu>
	 <200802071351.02763.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 7, 2008 12:21 AM, Balaji Rao <balajirrao@gmail.com> wrote:
> On Thursday 07 February 2008 01:32:45 pm Ingo Molnar wrote:
> > * Balaji Rao <balajirrao@gmail.com> wrote:
> > > Hello,
> > >
> > > The following commit caused my X server to stop working.
> > >
> > > commit 99fc8d424bc5d803fe92cad56c068fe64e73747a
> > > Author: Jesse Barnes <jesse.barnes@intel.com>
> > > Date:   Wed Jan 30 13:33:18 2008 +0100
> > >
> > >     x86, 32-bit: trim memory not covered by wb mtrrs
> > >
> > > This patch fixes the improper handling of addresses > 4G by
> > > mtrr_trim_uncached_memory. This, now brings up X on my system.
> >
> > thanks. Incidentally this same bug was reported and fixed yesterday, and
> > that fix is upstream already. Could you please compare your solution to
> > Yinghai Lu's fix below, and send us a patch for any further improvements
> > (or cleanups) you might notice in that code? It seems to be almost the
> > same fix as yours. (and hopefully it fixes your X problem too)
>
> Cool! Yes, Yinghai Lu's patch indeed is the same as mine and its really
> surprising that we've used the same variable name too! :)

minor difference
+               trim_start = highest_pfn << PAGE_SHIFT;
+               trim_size = end_pfn << PAGE_SHIFT;

could cause some problem with 32 bit kernel when mem > 4g.
becase highest_pfn and end_pfn is unsigned long aka 32 bit ...could overflow.

so need to assign thtem to trim_start/trim_end at first
or
+               trim_start = (u64)highest_pfn << PAGE_SHIFT;
+               trim_size = (u64)end_pfn << PAGE_SHIFT;

YH
