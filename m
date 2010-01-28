Return-Path: <linux-kernel-owner+w=401wt.eu-S1756451Ab0A1TDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab0A1TDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 14:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946Ab0A1TDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 14:03:38 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:51217 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753748Ab0A1TDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 14:03:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=rKUFI2nNcLMO13dr52lUiFVip2W+t6L166mSNeRcZP6cUjhBqQYSEZzo2ueGGl0nksno6oYwfkhS3BS1MLQDZEH+gDjb+KQvSsP48hcGp9drMLS7JUVOOqrA3AAdJJII;
Date: Thu, 28 Jan 2010 11:03:31 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garrett <jeff@jgarrett.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, Myron Stowe <myron.stowe@hp.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with
 pci=use_crs)
Message-ID: <20100128110331.61455a15@jbarnes-piketon>
In-Reply-To: <4B61D554.9000003@kernel.org>
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera>
	<1264652762.24020.5.camel@dc7800.home>
	<4B61266F.1060600@kernel.org>
	<201001280909.46043.bjorn.helgaas@hp.com>
	<4B61D554.9000003@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jan 2010 10:20:04 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> On 01/28/2010 08:09 AM, Bjorn Helgaas wrote:
> > On Wednesday 27 January 2010 10:53:51 pm Yinghai Lu wrote:
> >> On 01/27/2010 08:26 PM, Bjorn Helgaas wrote:
> >>> On Wed, 2010-01-27 at 15:34 -0800, Yinghai Lu wrote:
> > 
> >>>> 2. how about when apci is disabled?
> >>>
> >>> When ACPI is disabled, I think we just have to accept that we
> >>> lose some functionality.  I don't see the need for alternate ways
> >>> to accomplish everything that ACPI does.  It's becoming less and
> >>> less useful to disable ACPI; I think it's only interesting as a
> >>> debugging tool, and even then it's a sledgehammer.
> >>
> >> some systems when acpi is enabled could have interrupt storm. 
> >> and have to disable acpi.
> > 
> > We should fix that problem rather than just covering it up by
> > disabling ACPI.  Can you provide any details?
> that is not covering problem. acpi just cause too many problems.
> 
> systems using acpi hotplug support, and use acpi aml code to monitor
> the hotplug status instead of HW and after one or two days will have
> interrupt storm with sci/acpi interrupt aka 9.


But disabling it gets us into trouble too.  When platforms are designed
for Linux, they may be designed to have ACPI disabled (though this is
probably rare for general purpose PCs and servers).  However when
they're designed for Windows, they're generally designed to use ACPI,
so if we disable it we run the risk of hitting all sorts of bugs since
we're running in an untested configuration.

So fixing the issues with ACPI enabled seems like a better idea; after
all, presumably Windows works on this platform with ACPI enabled, why
shouldn't we?

But I'm speaking in general here; we'd have to dig into the details of
the particular problem you mention to figure out the best course of
action (but I'm still pretty sure it's not "disable ACPI").

-- 
Jesse Barnes, Intel Open Source Technology Center
