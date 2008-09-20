Return-Path: <linux-kernel-owner+w=401wt.eu-S1754142AbYITX4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbYITX4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 19:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbYITX4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 19:56:30 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:37879 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbYITX43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 19:56:29 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Sat, 20 Sep 2008 17:56:24 -0600
User-Agent: KMail/1.9.9
Cc: Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org,
       Rene Herman <rene.herman@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200809091250.08620.elendil@planet.nl> <200809172310.01580.bjorn.helgaas@hp.com> <200809210149.07755.elendil@planet.nl>
In-Reply-To: <200809210149.07755.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809201756.25157.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 September 2008 05:49:05 pm Frans Pop wrote:
> On Thursday 18 September 2008, Bjorn Helgaas wrote:
> > On Tuesday 09 September 2008 12:31:09 pm Rene Herman wrote:
> > > On 09-09-08 19:40, Bjorn Helgaas wrote:
> > > > If the PCI device isn't fully initialized, it doesn't seem right to
> > > > check it for resource conflicts.  But I don't know how to tell
> > > > that.
> > >
> > > His pci_resource_start() values are 0. How about just checking for
> > > that?
> >
> > Frans, can you test Rene's patch?  I think it will solve the problem
> > you're seeing, and if so, we should put it in for 2.6.27.  But I'd like
> > to have your "Tested-by" first.
> 
> Tested against current git (v2.6.27-rc6-158-g9824b8f) and looks good.
> Attached the patch with Rene's Signed-off and my Tested-by for 
> convenience.
> 
> I had not tested earlier as you said you wanted to better understand the 
> cause first. Did you get anything more about why things happen as they do 
> from the info I sent?

Thanks for testing this.

We're looking at some other issues in the same area, or at least,
where the fix might be in the same area:
  http://bugzilla.kernel.org/show_bug.cgi?id=10231
  http://bugzilla.kernel.org/show_bug.cgi?id=9904

I am still not 100% comfortable with this because I think we really
want to know whether the BAR value is zero, not whether the CPU
address is zero, and pci_resource_start() gives us the CPU address.

Bus and CPU addresses are currently identical on x86, but I expect
that will change someday.  They're already different on ia64 and
some other architectures.

Bottom line, I think we should tweak the patch to check the BAR
address before we put it in.

Bjorn

