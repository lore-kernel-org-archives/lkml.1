Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZBSDWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZBSDWV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 22:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZBSDWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 22:22:11 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:5275 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZBSDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 22:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Gh52vNQKR1z90AS5g0kFVATxC46Kil+x9Woo+HaeLdM8aE9XBhQE4sO7Ogm9P6f7Jo
         UXYZY1XomnkRDk3YbDJBk0+thIfG03LwPOOFuebXUtpt1wBISOlh8bqYLZZEBtximzcw
         abSX5a+aw7eKmWXMNlI/th6JzbLgEMMisjenI=
Message-ID: <499CD05D.2000505@gmail.com>
Date: Wed, 18 Feb 2009 21:22:05 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Heinz Diehl <htd@fancy-poultry.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28.[5,6] _GTF unexpected object type 0x1
References: <20090218132835.GA7253@fancy-poultry.org>
In-Reply-To: <20090218132835.GA7253@fancy-poultry.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heinz Diehl wrote:
> Hi,
> 
> did switch to 2.6.28.6 from 2.6.25 today on my Lenovo 3000 N200 Laptop,
> and noticed this error while booting (which wasn't there with 2.6.25):
> 
> [....]
> <6>ata3: SATA max UDMA/133 abar m2048@0xfc504000 port 0xfc504200 irq 507
> <6>ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> <4>ACPI Warning (nspredef-0852): \_SB_.PCI0.SATA.PRT0._GTF: Return type mismatch - found Integer, expected Buffer [20080926]
> <4>ata1.00: _GTF unexpected object type 0x1
> <6>ata1.00: ATA-7: WDC WD1600BEVS-08RST2, 08.01G08, max UDMA/133
> <6>ata1.00: 312581808 sectors, multi 16: LBA48 NCQ (depth 31/32)
> <4>ata1.00: _GTF unexpected object type 0x1
> <6>ata1.00: configured for UDMA/133
> [....]
> 
> So far, all seems to work properly, but I haven't used the machine any
> longer yet. 
> 
> Is this a serial issue which I have to worry about, and what can I do to avoid it?

It means your BIOS returns an incorrect object from the ACPI _GTF method 
which is used to figure out what ATA commands should be used to resume 
the hard drive properly. In this case the kernel just doesn't send such 
BIOS-provided commands. Usually these aren't necessary as the kernel 
knows how to re-initialize the drive itself, so it's likely not a 
serious problem.
