Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYIJVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYIJVen (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbYIJVee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:34:34 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:30839 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbYIJVed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:34:33 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Frans Pop <elendil@planet.nl>
Subject: Re: [bisected][resend] pnp: Huge number of "io resource overlap" messages
Date: Wed, 10 Sep 2008 15:34:27 -0600
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Matthew Wilcox <matthew@wil.cx>
References: <200809091250.08620.elendil@planet.nl> <200809091140.25597.bjorn.helgaas@hp.com> <200809100939.17045.elendil@planet.nl>
In-Reply-To: <200809100939.17045.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809101534.27688.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 01:39:15 am Frans Pop wrote:
> On Tuesday 09 September 2008, Bjorn Helgaas wrote:
> > If the PCI device isn't fully initialized, it doesn't seem right to
> > check it for resource conflicts.  But I don't know how to tell that.
> >
> > Can you figure out where the 1f.5 and 1f.6 resources get assigned?
> 
> If the approach suggested by Rene feasible or would you still like me to 
> get this info? In the last case I'll need some pointers where exactly to 
> look.

Checking pci_resource_start() for zero would certainly work
in your particular case.  But I don't know enough about PCI to
know whether that's always safe.

Matthew Wilcox suggested that the BARs may be zero because the BIOS
has "disabled" those two devices.  Are there any BIOS setup options
related to them?  I know you need to use at least the sound device,
so I'm not suggesting that Linux should leave it disabled;  I'm just
trying to learn more about the situation.

If I were trying to figure out where we assign resources, I'd probably
boot with "pci=earlydump" and sprinkle calls to early_dump_pci_device()
in pcibios_resource_survey(), and drill down from there.

Bjorn
