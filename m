Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbXFLR7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbXFLR7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 13:59:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbXFLR7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 13:59:00 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50253 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbXFLR67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 13:58:59 -0400
Date: Tue, 12 Jun 2007 20:00:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Jan Beulich <jbeulich@novell.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: [PATCH] x86: fix improper .init-type section references
Message-ID: <20070612180002.GC15329@uranus.ravnborg.org>
References: <466E6BDF.76E4.0078.0@novell.com> <a781481a0706120414g385ccfe8j82b5b18d96d064f2@mail.gmail.com> <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com> <466EB12B.76E4.0078.0@novell.com> <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com> <466EC08A.76E4.0078.0@novell.com> <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 07:39:30PM +0530, Satyam Sharma wrote:
> On 6/12/07, Jan Beulich <jbeulich@novell.com> wrote:
> >>> And from a purely theoretical
> >>> perspective I don't think such references should be considered bad -
> >>> .exit.* should be discarded together with .init.* if unloading is
> >>> impossible (built-in or configured off), not before module/kernel
> >>> initialization.
> >>
> >>Hmm, but that's not how things are, presently. __exit marked
> >>functions are simply not linked into the kernel (when that module
> >>is being built-in) at all -- this "discard" happens at _build time_
> >>(to save on kernel image size).
> >
> >Not really, at least not for i386 and x86-64 - see their vmlinux.lds.S 
> >files.
> 
> For those archs, yes, you're right that modpost should be
> special-casing (based on arch) before complaining for
> .init -> .exit references.
No.
References from __init to __exit is wrong independent on architecture.
powerpc discards them at buildtime, i386 at runtime.
So for the latter we will have an oops where we for the first have a build
time failure.
It is better to let modpost warn always - independent on architecture.

	Sam
