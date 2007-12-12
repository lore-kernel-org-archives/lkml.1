Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbXLLAJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbXLLAJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXLLAJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:09:05 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:14614 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbXLLAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:09:04 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: bbpetkov@yahoo.de
Subject: Re: 2.6.24-rc4-mm1: acpi reboots machine... solved
Date: Tue, 11 Dec 2007 17:08:59 -0700
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, len.brown@intel.com,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20071209075001.GA4686@gollum.tnic> <200712111300.24841.bjorn.helgaas@hp.com> <20071211205255.GB5013@gollum.tnic>
In-Reply-To: <20071211205255.GB5013@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712111709.00313.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007 01:52:55 pm Borislav Petkov wrote:
> From what i can roughly tell so far it seems like an resource conflict between acpi and
> the pnp requested regions in your patch which result in the acpi_thermal code
> to read the wrong (0xff) temperature value and halt the machine, but i might be
> wrong on the details since acpi is such a big code chunk to swallow.

I don't see any obvious conflict from the log you posted.  For the sake
of comparison, can you post the corresponding dmesg log after you removed
the patch?

acpi_thermal_get_temperature() only evaluates _TMP, which isn't very
interesting.  I wonder if there's some conflict between that AML method
and the EC driver or something.

If you can also collect the DSDT, maybe I can poke around in there and
see what _TMP is really doing.

Thanks,
  Bjorn
