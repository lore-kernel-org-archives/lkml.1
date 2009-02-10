Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZBJPEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZBJPEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 10:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZBJPEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 10:04:41 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:52552 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZBJPEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 10:04:40 -0500
Date: Tue, 10 Feb 2009 15:04:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       Corentin Chary <corentincj@iksaif.net>
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
Message-ID: <20090210150431.GA26798@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> <20090209234911.GB862@elte.hu> <5030E21460%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5030E21460%linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 02:12:44PM +0000, Darren Salt wrote:

> Reverting this fixes the rfkill oops; things work correctly again. I don't
> know why this appears to be needed, since things work fine without this patch
> ‒ both Fn-F2 and echoing to /sys/class/rfkill/rfkill0/state ‒ even when I
> start up with init=/bin/sh and test directly from that shell.

If this is BIOS version specific I'm going to be upset, but the general 
case behaviour is that rfkill only works on the 901 if you either (a) 
pass force=1 to pciehp (which you shouldn't) or (b) have native support 
in a driver. My /guess/ is that you've got pciehp loaded, and there's 
some kind of awkward race between it and eeepc-laptop.

>   input: ETPS/2 Elantech Touchpad as /class/input/input5
>   eeepc: Hotkey init flags 0x41
> (not seen in .28 or .28.1; not checked later .28.*.)

BIOS bug. There's an explicit delay in the eee bios for some reason, and 
I haven't found any straightforward way to avoid it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
