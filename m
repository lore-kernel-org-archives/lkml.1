Return-Path: <linux-kernel-owner+w=401wt.eu-S932753Ab0AFUa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab0AFUa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580Ab0AFUa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:30:26 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50221 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab0AFUaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:30:25 -0500
Date: Wed, 6 Jan 2010 20:29:18 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
Message-ID: <20100106202918.GA22957@srcf.ucam.org>
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain> <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org> <20100106143640.GB13984@srcf.ucam.org> <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain> <20100106193608.GA21447@srcf.ucam.org> <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001061504110.4086@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 03:22:30PM -0500, Len Brown wrote:

> I've looked at _OSI use in over a hundred DSDTs and never
> seen run-time re-configuration of reset support.

The point isn't that the firmware changes its behaviour - the point is 
that the OS does.

> I do not think the BIOS has a run-time decision to make here.
> If a box is designed to support Windows XP and newer, it is
> likely that ACPI_RESET is simply valid and XP blindly uses it.
> If reset fails, the box doesn't pass WHQL and the box is fixed.
> If W2K is run on that box, ACPI_RESET is still valid, just that
> W2K chooses to not write to it.

And if ACPI_RESET is set but untested (because 2000 never used it)?

> We can't rely on blind use of _OSI to mean "new enough", since
> it was supported back in W2K era.  That means we have to parse
> the OSI strings.  But what happens when a BIOS writer decides to
> evaluate _OSI("Windows Future") without evaluating any of the
> old strings we know about?  We would disable ACPI reset on such
> a future box?

Potentially, yes. But since such a machine would clearly expect to be 
treated as "Windows Future", we'd be running it in an untested 
configuration anyway.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
