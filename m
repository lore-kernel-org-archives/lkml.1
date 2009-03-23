Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZCWWXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZCWWXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbZCWWXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:23:35 -0400
Received: from outbound-mail-302.bluehost.com ([67.222.53.9]:48885 "HELO
	outbound-mail-302.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752244AbZCWWXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:23:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gRvouH1GVTke+7A0JiiRGEsSMjxElO/OJORXo1HNmo/AdjQo7MnvvO2k4ulBoFnE//Ly/GlrdoRY3L02YMn/fs4wJt86CxKZoRJCv1b1C0lXrCF7fycrMrOEacrcrBfi;
Date: Mon, 23 Mar 2009 15:23:30 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/2] Export platform_pci_set_power_state() and make
 radeonfb use it
Message-ID: <20090323152330.536a5a1c@hobbes.virtuouswap>
In-Reply-To: <200903232230.10831.rjw@sisk.pl>
References: <200903210003.55161.rjw@sisk.pl>
	<200903222208.22434.rjw@sisk.pl>
	<200903232230.10831.rjw@sisk.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Mar 2009 22:30:09 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Sunday 22 March 2009, Rafael J. Wysocki wrote:
> > On Saturday 21 March 2009, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > The story in http://bugzilla.kernel.org/show_bug.cgi?id=12846
> > > shows that setting the power state of a PCI device by
> > > pci_raw_set_power_state() may sometimes fail.  For this reason,
> > > pci_raw_set_power_state() should not assume that the power state
> > > of the device has actually changed after writing into its PMCSR.
> > > Instead, it should read the value from there and use it to update
> > > dev->current_state.  It also is useful to print a warning if the
> > > device's power state hasn't changed as expected.
> > > 
> > > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > ---
> > OK, since the Ben's radeonfb fix for bug #12846 has been merged,
> > I'd like to do something a bit different.
> > 
> > Patch 1/2 introduces __pci_set_power_state() that will allow the
> > radeonfb driver not to open code PCI PM operations.
> > 
> > Patch 2/2 makes the driver use __pci_set_power_state().
> > 
> > Comments welcome.
> 
> Well, Jesse doesn't like these patches very much, so here's an
> alternative.
> 
> 1/2 changes platform_pci_set_power_state() into an exported function
> (and uses it to simplify pci_set_power_state() a bit) so that the
> radeonfb driver can use it.
> 
> 2/2 modifies the radeonfb driver itself.

The thing I didn't like was that it made the radeon driver use an
internal interface; I'd really prefer a proper return value from
pci_set_power_state, which in turn means auditing all its current
callers. But that doesn't seem worth it unless we see other drivers
needing something similar...

And if we did go with something like your first patch, I'd still rather
see the timeout done in the driver, rather than having the attempts &
delay included in the function...

-- 
Jesse Barnes, Intel Open Source Technology Center
