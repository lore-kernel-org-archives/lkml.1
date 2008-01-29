Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYA2WY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYA2WY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:24:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757968AbYA2WXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:23:21 -0500
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:42579 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758337AbYA2WXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:23:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=nDjD7vpMMV+oHM5oH97dlDyx9ruMyv3UDmplviGRgz0/2NnMnuwGnN0N61QdwJFhwOxhvDP+88jc+6Vyq55YBYoUVk8Tj+Q5HRw8Y+IA+qoDZ6Irk5nRk65JMNCMUpTjo2v2em0w8IqD5e8egPkVnnNsFFzd2vhOasUIoIJRWoY=;
X-YMail-OSG: t4SX3PsVM1ku9Hmjh5FFkf1blh2BHsbkY7iQMmda.4oENY67OndSp_OvYzeJSMJslIc4dg--
X-Mailer: YahooMailWebService/0.7.162
Date: Tue, 29 Jan 2008 14:23:15 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: DMA mapping on SCSI device?
To: Robert Hancock <hancockr@shaw.ca>, Andi Kleen <ak@suse.de>
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
In-Reply-To: <200801290528.00934.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <593242.13701.qm@web31807.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Mon, 1/28/08, Andi Kleen <ak@suse.de> wrote:
> > The ideal solution would be to do mapping against a
> different struct
> > device for each port, so that we could maintain the
> proper DMA mask for
> > each of them at all times. However I'm not sure if
> that's possible.
> 
> I cannot imagine why it should be that difficult. The PCI
> subsystem
> could over a pci_clone_device() or similar function.   For
> all complicated
> purposes (sysfs etc)  the original device could be used, so
> it would
> be hopefully not that difficult.
> 
> The alternative would be to add a new family of PCI mapping
> functions that take an explicit mask. Disadvantage would be
> changing 
> all architectures, but on the other hand the interface
> could be phase
> in one by one (and nF4 primarily only works on x86 anyways)
> 
> I suspect the later would be a little cleaner, although
> they don't
> make much difference.

Yes, I guess, that's certainly doable.

The current PCI abstraction is clean: HW DMA engine(s) implementation
is a property of the PCI function.

Marrying different behaviour of the HW DMA engine of the ASIC
depending on the SCSI end device at the PCI device abstraction doesn't
sound good. (An extreme design is a single DMA engine servicing
the ASIC.)

Although, the effect that Rob wants could be cleanly implemented
at a higher level, pci_map_sg() and such, or fixing 
blk_queue_bounce_limit() in x86_64 to that effect.

    Luben

