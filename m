Return-Path: <linux-kernel-owner+w=401wt.eu-S932654Ab0AFThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab0AFThW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453Ab0AFThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:37:21 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47260 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343Ab0AFThT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:37:19 -0500
Date: Wed, 6 Jan 2010 19:36:08 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Len Brown <lenb@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
Message-ID: <20100106193608.GA21447@srcf.ucam.org>
References: <20100104162114.GA30113@percival.namespace.at> <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain> <4B4225B3.8070705@zytor.com> <20100104174558.158cd512@infradead.org> <20100106143640.GB13984@srcf.ucam.org> <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001061321260.4086@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 06, 2010 at 02:26:44PM -0500, Len Brown wrote:

> But...
> using _OSI is not "a similar method to Windows".
> The BIOS does not need to invoke _OSI to determine if
> it should expose a properly functioning ACPI reset or not.
> Windows XP simply demanded it, and the box failed WHQL
> if it did not work.

http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/WinACPI_OSI.docx 
was what I was referring to:

"By using the _OSI method, ASL writers can easily determine the version 
of the ACPI interfaces that the host operating system supports. This 
versioning method provides a solution for creating firmware that can 
support future operating systems and enable the operating system to 
change behavior based on the requested interface levels."

We know that this is used for deciding whether or not to block system IO 
accesses, but it wouldn't surprise me if it's also used to determine 
other functionality like whether or not the ACPI interface is used for 
rebooting.

> Further, there is no _guarantee_ that a BIOS will invoke _OSI
> at all, let alone a _rule_ for what _OSI() strings the BIOS
> will choose to query to trigger its Windows specific
> compatibility hooks -- even if common practice is for
> a desktop BIOS to evaluate _OSI strings in sequence
> up throught he most recent version of Windows it
> knows about...

It's effectively guaranteed if the system is validated with Windows.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
