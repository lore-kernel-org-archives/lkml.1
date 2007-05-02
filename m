Return-Path: <linux-kernel-owner+w=401wt.eu-S2992643AbXEBC4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992643AbXEBC4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 22:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992644AbXEBC4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 22:56:42 -0400
Received: from outbound-mail-53.bluehost.com ([69.89.20.33]:43917 "HELO
	outbound-mail-53.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S2992643AbXEBC4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 22:56:41 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Tue, 1 May 2007 19:56:29 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <20070430225916.GA39223@dspnet.fr.eu.org> <200705011941.07438.jbarnes@virtuousgeek.org>
In-Reply-To: <200705011941.07438.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705011956.30629.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 01, 2007, Jesse Barnes wrote:
> On Monday, April 30, 2007, Olivier Galibert wrote:
> > On Sun, Apr 29, 2007 at 08:14:37PM -0600, Robert Hancock wrote:
> > > -Validate that the area is reserved even if we read it from the
> > > chipset directly and not from the MCFG table. This catches the case
> > > where the BIOS didn't set the location properly in the chipset and
> > > has mapped it over other things it shouldn't have.  This might be
> > > overly pessimistic - we might be able to instead verify that no
> > > other reserved resources (like chipset registers) are inside this
> > > memory range.
> >
> > I have a fundamental problem with that: you don't validate a higher
> > reliability information against a lower one.  The chipset registers
> > are high reliability.  Modulo unknown hardware erratas and bugs in the
> > code (and accepting f0000000 is in practice a bug in the code, the
> > docs are starting to catch up with it too), the chipset *will* decode
> > mmconfig at the looked up address no matter what.  On the other side,
> > the ACPI data is bios generated, and that is well known to be horribly
> > unreliable.  Hell, if it was reliable we could just use the MFCG ACPI
> > table without questions.
>
> Now that I've read his patch closely I think you're right.
>
> Robert, it looks like you'll trust acpi_table_parse if
> pci_mmcfg_check_hostbridge returns a failure.  I think it should be
> treated with a higher priority.  If pci_mmcfg_check_hostbridge returns a
> failure, there's no way MCFG space can work, so we should disable it
> unconditionally in that case (even if ACPI says "trust me, when have I
> ever lied to you?").
>
> I'm testing it now on my 965...

Bah... nevermind Robert, I see you're doing this already in 
pci_mmcfg_reject_broken.  I'm about to reboot & test now.

Jesse
