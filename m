Return-Path: <linux-kernel-owner+w=401wt.eu-S1761272AbZBLMst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761272AbZBLMst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:48:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760574AbZBLMpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:45:02 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:29401 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760567AbZBLMo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:44:59 -0500
Date: Thu, 12 Feb 2009 13:44:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Len Brown <lenb@kernel.org>,
       Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
Message-ID: <20090212134434.719d6f7a@hyperion.delvare>
In-Reply-To: <20090210140829.GA25397@srcf.ucam.org>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	<200901291130.35434.trenn@suse.de>
	<68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
	<alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
	<20090204060513.GA28321@srcf.ucam.org>
	<498953DF.5050306@redhat.com>
	<20090204131708.GA2739@srcf.ucam.org>
	<20090204142606.1823661b@hyperion.delvare>
	<20090204142015.GB3923@srcf.ucam.org>
	<20090210145716.105ab58b@hyperion.delvare>
	<20090210140829.GA25397@srcf.ucam.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Feb 2009 14:08:29 +0000, Matthew Garrett wrote:
> On Tue, Feb 10, 2009 at 02:57:16PM +0100, Jean Delvare wrote:
> 
> > In theory you are, of course, perfectly right. The question is, how do
> > we get there without making people angry because of the regression? 
> 
> The only thing we can do is add a printk that informs users that passing 
> a boot argument will allow them to use the drivers as they used to.

Good point.

> > The same chip can be driven by our native it87 driver, which, on this
> > specific board, provides support for 9 voltages, 3 fans, and 1 working
> > temperature. Do we really have to tell the user to not use the it87
> > driver and instead use the ACPI thermal driver "because that's what the
> > firmware wants"?
> 
> It's valid (if dumb) for vendors to design their platforms such that 
> enabling ACPI and then not using the thermal code may result in hardware 
> damage. We have no way of determining that in advance, so all we can do 
> is tell the user that they can pass an argument if they know it's safe 
> to do so.

OK, I understand.

> > But I guess there is no way to know what exactly the ACPI thermal zone
> > is doing, except by looking at the DSDT, so this can't be automated?
> 
> Correct.
> 
> > Is it at least possible to disable the ACPI thermal zone either as a
> > command-line parameter or an internal blacklist?
> 
> It's possible, and we could certainly add an argument to do so. However, 
> removing support for the kernel use of the thermal zone doesn't prevent 
> the firmware from making calls to the thermal code itself. There's no 
> real way we can block that.
> 
> > One approach that may work is to change the default based on the ACPI
> > implementation year (I think the info is available, right?) We could
> > default to strict for systems with year >= 2009. This may still prevent
> > users from getting the best out of their system, but at least won't
> > cause a regression for users of older systems where the native driver
> > has been used so far. I know it's not an ideal solution, but ACPI
> > implementations aren't ideal either.
> 
> The problem with this approach is that we still end up with a large 
> number of malfunctioning machines.

Well, that's what we have at the moment and the world didn't end.
Enabling strict checks for a subset of machines is always an
improvement compared to the current situation.

> Really, I don't think there's any way 
> to handle this other than defaulting to strict, letting the default be 
> changed at run and boot time and printing a message when a driver is 
> refused permission to bind. Distributions that want to obtain the 
> previous behaviour can change the default back.

Anyway, as I already wrote elsewhere in this thread, I no longer object
to the change you propose. I won't instigate it, but if it happens,
and care is taken to address the foreseeable downfalls, fine with me.

Thanks,
-- 
Jean Delvare
