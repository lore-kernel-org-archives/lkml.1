Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811Ab0ANAmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0ANAmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600Ab0ANAmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:42:53 -0500
Received: from mail-iw0-f194.google.com ([209.85.223.194]:57649 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab0ANAmw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:42:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kKdBfD1oq5A1+yADd3JItWxZc26s3Po7BfqON96k21WGBYX7ry9OpU1HX1xXZgvyYg
         z8gDR0xVzxyQob9vxcyefeJz+Y4fi0nu75k3WbNZ+LGzj7r8mCH0owur6mfXQtCEOKGT
         KMmlKr3RVLG+WgFx3MeHa//uxn00jiwokvXmA=
MIME-Version: 1.0
In-Reply-To: <51f3faa71001131611y343ad225n1acc73900fd49894@mail.gmail.com>
References: <201001121700.18234.seth.heasley@intel.com>
	 <4B4D4EAA.2010109@gmail.com> <4B4DAA68.60608@pobox.com>
	 <51f3faa71001131611y343ad225n1acc73900fd49894@mail.gmail.com>
Date: Wed, 13 Jan 2010 18:42:51 -0600
Message-ID: <51f3faa71001131642u2cc9de80n8e73be7a8707afb2@mail.gmail.com>
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel 
	Cougar Point DeviceIDs
From: Robert Hancock <hancockrwd@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Seth Heasley <seth.heasley@intel.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 6:11 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On Wed, Jan 13, 2010 at 5:11 AM, Jeff Garzik <jgarzik@pobox.com> wrote:
>>> Likely a lot of the existing specific PCI IDs could be removed from the
>>> driver because of this (many likely predate the addition of the
>>> class-based catch-all). The only reason to need a specific entry if the
>>> device uses AHCI class is if it needs special handling or workarounds,
>>> which isn't the case here.
>>
>> Well, two lines of thinking here:
>>
>> * some of lines of Intel chips do not separate AHCI into a separate PCI ID
>> rather legacy IDE interface.  When an AHCI interface exists and AHCI/IDE
>> share the same PCI ID, we default to using AHCI.  Thus, some of those PCI ID
>> matches in ahci.c's PCI table may not get caught by the generic PCI class
>> match at the end of the table.
>
> Well, ata_piix does have a couple of entries that are listed in ahci
> as well, for ICH6 device IDs 0x2652 and 0x2653. For 0x2653 ata_piix
> checks the class code to make sure it's IDE, but for the 0x2652 entry,
> and in both cases in ahci, the class code isn't checked. Deleting the
> specific entries from ahci for those controllers would seemingly
> actually improve the situation, since then ahci wouldn't try and
> attach to those devices when they indicate IDE class. ata_piix should
> also should be checking for IDE class on 0x2652 as well.

Hmm, it seems like it's a bit more complicated than that. For ICH6R
(0x2652), ata_piix attaches to it regardless of mode intentionally, it
has specific logic to disable AHCI on the controller since it can be
used in either mode. That seems a bit questionable. Having the same
device being handled by different enabled drivers and depending on
link or module load order to decide which one loads is fragile and
prone to errors. I'd be in favor of removing the ICH6R support from
ata_piix entirely and saying that you should be using ahci for that
device. Maybe when ahci was immature there was a benefit to allowing
ata_piix to run it, but I doubt that's true today.
