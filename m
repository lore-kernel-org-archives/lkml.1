Return-Path: <linux-kernel-owner+w=401wt.eu-S1761148AbXGDAf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148AbXGDAf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 20:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760888AbXGDAef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 20:34:35 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:45627 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760855AbXGDAee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 20:34:34 -0400
Date: Wed, 4 Jul 2007 01:34:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Message-ID: <20070704003424.GA30958@srcf.ucam.org>
References: <fa.ftLWBLCc+XqdYjiuxoPg+qyuUOE@ifi.uio.no> <fa.Oxrm8HYXTOF4jv5LrTjEe16lCE0@ifi.uio.no> <fa.d3GOse+YbAb42uYwLymWkJiH9Fw@ifi.uio.no> <468AE700.7080102@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468AE700.7080102@shaw.ca>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2007 at 06:17:04PM -0600, Robert Hancock wrote:
> Matthew Garrett wrote:
> >Leave the process blocked and defer any i/o until after resume. Why does 
> >it need to be any more complicated than that?
> 
> It gets complicated when this has to be added and TESTED in EVERY 
> driver. The implied contract for drivers previously was that their 
> device would not get accessed after it was suspended until it had been 
> resumed first. This proposed change violates that.

No, that's only ever been true for ACPI systems. It's never been true 
elsewhere, and it won't be true for anything implementing any sort of 
runtime power management.

> I don't think this sort of handling is something that individual drivers 
> should have to deal with (at least not ones that are part of a framework 
> like USB, libata, etc.)

I'd agree there. Driver midlayers (where they exist) are the appropriate 
place to handle this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
