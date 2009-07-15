Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbZGOXJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbZGOXJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 19:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbZGOXJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 19:09:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37914 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753695AbZGOXJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 19:09:34 -0400
Date: Thu, 16 Jul 2009 00:10:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Alan Cox <alan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hans de Goede <hdegoede@redhat.com>
Subject: Re: Why do we probe option roms at 2K boundaries?
Message-ID: <20090716001016.489fa970@lxorguk.ukuu.org.uk>
In-Reply-To: <1247698965.3989.1.camel@dwillia2-linux.ch.intel.com>
References: <1247698965.3989.1.camel@dwillia2-linux.ch.intel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> interrogating a data structure stored in option-rom memory.  My initial
> implementation involved blindly scanning from c0000 to f0000 in 512 byte
> increments.  Neil and others pointed out that this may not be a safe

It isn't safe. If you hit certain ISA devices your system will drop dead.
OTOH I doubt anyone has an intel matrix raid controller and a WD80x3 on
the same box ;)

> Recently Hans has been working to get Fedora up and running on a recent
> Intel software RAID platform and noticed that the option-rom is no
> longer visible with the 2K aligned scan.  I.e. he needed to make the
> following changes to the mdadm probe_roms() routine:

Option ROMs should be 2K aligned. Is your data structure part of a ROM or
an actual ROM header ?

> Is this safe?  Should the kernel be updated as well?  I am assuming that
> you were the one that originally introduced the 2K aligned scan with
> this commit from the historical git:

Actually I don't think that was me, don't remember it anyway.

The man to bug at the moment on ROM magic is probably H Peter Anvin
however.

