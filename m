Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZGHQwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZGHQwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbZGHQwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:52:24 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:23068 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428AbZGHQwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:52:23 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: David =?iso-8859-1?q?H=E4rdeman?= <david@hardeman.nu>
Subject: Re: [PATCH 1/2] ACPI: reintroduce acpi_device_ops .shutdown method
Date: Wed, 8 Jul 2009 10:52:19 -0600
User-Agent: KMail/1.9.10
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
       jbarnes@virtuousgeek.org, "Len Brown" <lenb@kernel.org>
References: <1246079912-17619-1-git-send-email-david@hardeman.nu> <200906301711.34074.bjorn.helgaas@hp.com> <737c7bd0a2f550d21d45b347d018a1ac.squirrel@www.hardeman.nu>
In-Reply-To: <737c7bd0a2f550d21d45b347d018a1ac.squirrel@www.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907081052.20142.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 July 2009 02:20:59 am David Härdeman wrote:
> On Wed, July 1, 2009 01:11, Bjorn Helgaas wrote:
> > The winbond driver does not use any ACPI-specific functionality, so
> > it might be simpler to write it as a PNP driver (which would depend
> > on PNPACPI, of course).
> 
> As far as I could tell from a quick look at include/linux/pnp.h, a
> pnp_driver doesn't seem to have any .shutdown methods either, so I'm not
> sure how it would help?

PNPACPI parses the device resources for you, so you could get rid
of the _CRS stuff in your driver.

The only reason PNP and ACPI don't have .shutdown is because nobody
has needed it yet.  If you need it (and it sounds like you do), I
think the cleanest thing would be to add it to PNP and turn your
driver into a PNP driver.

Bjorn
