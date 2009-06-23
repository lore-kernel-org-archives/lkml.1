Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbZFWIq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbZFWIq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbZFWIqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:46:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54814 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751107AbZFWIqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:46:21 -0400
Date: Tue, 23 Jun 2009 09:47:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kevin Huang (=?big5?B?tsCzzaTl?=) <Kevin.Huang@rdc.com.tw>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <greg@kroah.com>, <torvalds@linux-foundation.org>
Subject: Re: Staging: add pata_rdc driver
Message-ID: <20090623094706.5df94c96@lxorguk.ukuu.org.uk>
In-Reply-To: <07905E0D268758488D76D7D747F21BB602B1FD86@rdc8.rdc>
References: <200906200109.n5K19iaC012636@hera.kernel.org>
	<20090622133222.3a689f22@lxorguk.ukuu.org.uk>
	<07905E0D268758488D76D7D747F21BB602B1FD86@rdc8.rdc>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 10:16:03 +0800
Kevin Huang (¶À³Í¤å) <Kevin.Huang@rdc.com.tw> wrote:

> I just know all pata follow the ATA ATAPI Host Adapters Standard.pdf.
> This standard describes all hardware interfaces for pata. (like sata and AHCI standard spec.)
> 
> The original draft does not have any Configuration Registers for Host Adapters. Then Intel proposes ATA Controller PCI Configuration Registers for this lack of the original draft, and T13 accept this proposal.

If your controller is in fact following the Intel proposal then the
interface is basically ata_piix (minus the various intel special cases)
and that makes it very much easier to produce a driver rapidly rather
than clean up the existing pata_rdc.

> Our new controller have crypto function and crypto configuration registers.
> So it don¡¦t like Intel controller.

It seems to be very very close in interface, and that does mean that
there is a fast way to get it up and running which is to clone ata_piix,
remove the irrelevant bits and tweak it. Then of course things like the
crypto function can be added on top.

Is the documentation for the ATA part available ?

Alan
