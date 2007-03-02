Return-Path: <linux-kernel-owner+w=401wt.eu-S2992475AbXCBOTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992475AbXCBOTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 09:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992474AbXCBOTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 09:19:12 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:39606 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992470AbXCBOTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 09:19:11 -0500
Date: Fri, 2 Mar 2007 14:18:40 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Message-ID: <20070302141840.GA3441@srcf.ucam.org>
References: <45D5EA88.7090300@redhat.com> <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302151055.d2665d66.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302151055.d2665d66.khali@linux-fr.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 03:10:55PM +0100, Jean Delvare wrote:

> I'm not familiar with APCI at all so I didn't know, but what you write
> here brings some hope. Would it be possible to parse all the DSDT code
> at boot time and deduce all the ports which ACPI would need to request
> to be safe? Or do we have to wait for the accesses to actually happen?

In theory I /think/ so, but it would probably end up being an 
overestimate of the coverage actually needed. Trapping at runtime is 
arguably more elegant?

> Do we know in advance when we are going to SMM mode and back? If we do,
> I'd be happy with a mutex every interested driver could use to protect
> relevant parts of its code. SMBus master drivers for example could
> request that mutex during SMBus transactions. Of course we don't know
> if SMM will actually touch the SMBus, but better safe than sorry I
> guess. And SMM calls aren't happening so frequently, are they?

My understanding is that pretty much arbitrary hardware access can cause 
SMM transitions without OS notification, though this is getting outside 
the areas I know about.
-- 
Matthew Garrett | mjg59@srcf.ucam.org
