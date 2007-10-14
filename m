Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbXJNKf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbXJNKf2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 06:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755278AbXJNKfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 06:35:13 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:3038 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275AbXJNKfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 06:35:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ub8ByacjqC8jD4Lxn23oWSX0CVG8U6GeYy7IO3fy3eW1ksxRtDoJUg1+fPX1la7Uu1k7dTvdTW35Df2xXN0YRxwSZgYTLF6bg/MUt1eQlIfs0k2TQwdKdDSAiJ1NWqsRhGwR2Bt1nDE1LCUTXwD5+mPmumWwAjiNmBBy18oGm4g=
Message-ID: <64bb37e0710140335g648a86ebmebdf32a6068abcf8@mail.gmail.com>
Date: Sun, 14 Oct 2007 12:35:08 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [git patches] libata update
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20071012194002.GA1545@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071012194002.GA1545@havoc.gtf.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Jeff Garzik <jeff@garzik.org> wrote:
> [ I just sent this upstream to Andrew and Linus ]
> * Turn on ACPI by default (watch for bug reports!).  This should make
>   suspend/resume work a lot better.

Bug report for 2.6.23-mm1:
scsi8 : pata_amd
scsi9 : pata_amd
ata9: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
ata10: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index
(0FFFFFFFF) is beyond end of object [20070126]
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.GTM_] (Node ffff810100318a20), AE_AML_PACKAGE_LIMIT
ACPI Error (psparse-0537): Method parse/execution failed
[\_SB_.PCI0.IDE0.CHN0._GTM] (Node ffff8101003187c0),
AE_AML_PACKAGE_LIMIT
ata9: ACPI get timing mode failed (AE 0x300d)
ata9.01: ATA-7: Maxtor 6L250R0, BAH41G10, max UDMA/133
ata9.01: 490234752 sectors, multi 16: LBA48
ata9.01: limited to UDMA/33 due to 40-wire cable
ata9.01: configured for UDMA/33
ata10: port disabled. ignoring.

libata-Bug, ACPI-Bug or just bad code in the BIOS?
The detection of the 40-wire cable is correct, also that there is only
one drive at this IDE port.

pata_amd is build as module and is driving the IDE part of a nVidia MCP55.

Torsten
