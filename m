Return-Path: <linux-kernel-owner+w=401wt.eu-S965647AbXCBVNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965647AbXCBVNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965645AbXCBVNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:13:16 -0500
Received: from cavan.codon.org.uk ([217.147.92.49]:38996 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965647AbXCBVNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:13:14 -0500
Date: Fri, 2 Mar 2007 21:12:51 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chuck Ebbert <cebbert@redhat.com>,
       Rudolf Marek <r.marek@assembler.cz>, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Message-ID: <20070302211251.GA10035@srcf.ucam.org>
References: <45D6DDCE.5050803@assembler.cz> <45D7461A.2040808@redhat.com> <20070218183805.5a4fd813.khali@linux-fr.org> <20070228213803.GA4877@ucw.cz> <20070301152655.f232db64.khali@linux-fr.org> <20070302114023.GD2163@elf.ucw.cz> <20070302114747.GB1212@srcf.ucam.org> <20070302151055.d2665d66.khali@linux-fr.org> <20070302141840.GA3441@srcf.ucam.org> <20070302220454.a0c66d04.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302220454.a0c66d04.khali@linux-fr.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 10:04:54PM +0100, Jean Delvare wrote:
> On Fri, 2 Mar 2007 14:18:40 +0000, Matthew Garrett wrote:
> > In theory I /think/ so, but it would probably end up being an 
> > overestimate of the coverage actually needed. Trapping at runtime is 
> > arguably more elegant?
> 
> It might be more elegant but it won't work. We don't want to prevent
> ACPI from accessing these I/O ports. If we need to choose only one
> "driver" accessing the I/O port, it must be acpi, at leat for now,
> despite the fact that acpi provides very weak hardware monitoring
> capabilities compared to the specific drivers.

Assuming arbitration of access, what's the problem with having two 
drivers accessing the same hardware? Do these chips generally have any 
significant internal state other than trip points and the like?

> Why would we end up with an overestimation if we check the I/O ports at
> boot time? Do you have concrete cases in mind?

ACPI will often describe large operation regions, but won't necessarily 
touch all of them. Effectively, every codepath would have to be walked 
through at boot time and checked for io access.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
