Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZBJOIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZBJOIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZBJOIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:08:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41842 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbZBJOIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:08:39 -0500
Date: Tue, 10 Feb 2009 14:08:29 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090210140829.GA25397@srcf.ucam.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200901291130.35434.trenn@suse.de> <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com> <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain> <20090204060513.GA28321@srcf.ucam.org> <498953DF.5050306@redhat.com> <20090204131708.GA2739@srcf.ucam.org> <20090204142606.1823661b@hyperion.delvare> <20090204142015.GB3923@srcf.ucam.org> <20090210145716.105ab58b@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210145716.105ab58b@hyperion.delvare>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 02:57:16PM +0100, Jean Delvare wrote:

> In theory you are, of course, perfectly right. The question is, how do
> we get there without making people angry because of the regression? 

The only thing we can do is add a printk that informs users that passing 
a boot argument will allow them to use the drivers as they used to.

> The same chip can be driven by our native it87 driver, which, on this
> specific board, provides support for 9 voltages, 3 fans, and 1 working
> temperature. Do we really have to tell the user to not use the it87
> driver and instead use the ACPI thermal driver "because that's what the
> firmware wants"?

It's valid (if dumb) for vendors to design their platforms such that 
enabling ACPI and then not using the thermal code may result in hardware 
damage. We have no way of determining that in advance, so all we can do 
is tell the user that they can pass an argument if they know it's safe 
to do so.

> But I guess there is no way to know what exactly the ACPI thermal zone
> is doing, except by looking at the DSDT, so this can't be automated?

Correct.

> Is it at least possible to disable the ACPI thermal zone either as a
> command-line parameter or an internal blacklist?

It's possible, and we could certainly add an argument to do so. However, 
removing support for the kernel use of the thermal zone doesn't prevent 
the firmware from making calls to the thermal code itself. There's no 
real way we can block that.

> One approach that may work is to change the default based on the ACPI
> implementation year (I think the info is available, right?) We could
> default to strict for systems with year >= 2009. This may still prevent
> users from getting the best out of their system, but at least won't
> cause a regression for users of older systems where the native driver
> has been used so far. I know it's not an ideal solution, but ACPI
> implementations aren't ideal either.

The problem with this approach is that we still end up with a large 
number of malfunctioning machines. Really, I don't think there's any way 
to handle this other than defaulting to strict, letting the default be 
changed at run and boot time and printing a message when a driver is 
refused permission to bind. Distributions that want to obtain the 
previous behaviour can change the default back.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
