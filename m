Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbYHMQ7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbYHMQ7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:59:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756847AbYHMQ6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:58:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37815 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756764AbYHMQ6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:58:49 -0400
In-Reply-To: <20080812231602.GB12838@kroah.com>
References: <20080812193031.GD18034@infradead.org> <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com> <20080812231602.GB12838@kroah.com>
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Kenneth Goldman <kgoldman@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       linux-security-module-owner@vger.kernel.org
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
X-KeepSent: 67E000CB:22C52D18-852574A4:005B9DAA;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OF67E000CB.22C52D18-ON852574A4.005B9DAA-852574A4.005D08CA@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Wed, 13 Aug 2008 12:56:40 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/13/2008 12:56:40,
	Serialize complete at 08/13/2008 12:56:40
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-security-module-owner@vger.kernel.org wrote on 08/12/2008 07:16:02 
PM:

> On Tue, Aug 12, 2008 at 04:57:31PM -0400, Kenneth Goldman wrote:
> > Christoph Hellwig <hch@infradead.org> wrote on 08/12/2008 03:30:31 PM:
> > 
> > > On Mon, Aug 11, 2008 at 05:13:51PM -0400, Mimi Zohar wrote:
> > > >
> > > > I assume the concern here is that between looking up the chip and
> > actually
> > > >
> > > > using the chip, the TPM chip is disabled/deactivated.  Based on
> > > > discussions
> > > > with Kenneth Goldman, the TCG main specification part2: 
structures,
> > > > require
> > > > that even if the TPM is disabled/deactivated, the command to 
extend the
> > 
> > > > PCR
> > > > will succeed, but the command to read the PCR will fail with an
> > > > appropriate
> > > > error code.
> > >
> > > And what happens when the chip simply goes away due to a hotplug 
action?
> > > Or not even the actual chip goes away but just the chip driver and 
you
> > > now dereference freed memory?
> > 
> > Being a TCG/TPM person, I can only address the first question.  The
> > intent is that the TPM is soldered to the planar/motherboard (the TCG
> > uses the phrase "bound to the platform").  I can't imagine
> > any manufacturer designing a pluggable TPM.  It would subvert PCR
> > measurements and thus attestation, data sealing, etc.
> 
> Load up the fake-php hotplug pci driver and "soft" disconnect it from
> the system :)
> 
> That was easy...
> 
> Note, just because you think your device is always going to be soldered
> to the motherboard, doesn't mean it can't be disconnected at any point
> in time with the kernel running.
>
> Or the module could just be unloaded, that's also a very common thing to
> have happen, right?

This problem only affects the TPM internal kernel interface, if the TPM 
driver is not built-in. For IMA, this is not an issue as the TPM driver 
must be built-in in order to start collecting measurements as soon as 
possible, which is at late_initcall().  I will resolve this problem for 
the general internal kernel interface usage case.

Thanks!

Mimi
