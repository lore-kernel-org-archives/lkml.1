Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0CJU4Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 15:56:25 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:37154 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0CJU4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 15:56:23 -0500
Date: Wed, 10 Mar 2010 20:56:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Pauli Nieminen <suokkos@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Luca Tettamanti <kronos.it@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net
Subject: Re: [Q] How to tell we're using the KMS (during suspend/resume)
	outside the graphics driver
Message-ID: <20100310205618.GA28628@srcf.ucam.org>
References: <201003062236.09801.rjw@sisk.pl> <201003091234.59598.rjw@sisk.pl> <alpine.LFD.2.00.1003091613390.30952@casper.infradead.org> <201003092208.28175.rjw@sisk.pl> <20100310055013.GC19518@linux-sh.org> <548cdfc21003100254t5c94aca5u5cf1e9eb29215325@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548cdfc21003100254t5c94aca5u5cf1e9eb29215325@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as the ACPI video driver goes, acpi_get_physical_pci_device() 
will give you something to work with. For the console-switching case, I 
think the most reasonable plan is probably to add a flag to the console 
drivers to indicate whether or not they support reprogramming the 
hardware themselves, and then walk all active console drivers. There'd 
need to be a way for fb drivers to tell fbcon that they can handle it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
