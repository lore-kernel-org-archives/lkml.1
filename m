Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYJTUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYJTUyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYJTUyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 16:54:00 -0400
Received: from mail91.analogic.com ([12.187.86.31]:54949 "EHLO
	mail01.analogic.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752227AbYJTUx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 16:53:59 -0400
X-Greylist: delayed 1533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Oct 2008 16:53:59 EDT
X-AuditID: 0a770115-a8994bb000000e9b-02-48fce9de3811
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
x-mimeole: Produced By Microsoft Exchange V6.5
x-originalarrivaltime: 20 Oct 2008 20:28:12.0671 (UTC) FILETIME=[5FC0B8F0:01C932F2]
Content-class: urn:content-classes:message
Subject: Re: discarded `.exit.text' debugging?
Date: Mon, 20 Oct 2008 16:28:12 -0400
Message-ID: <Pine.LNX.4.61.0810201616190.9702@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.64.0810202207140.23258@anakin>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: discarded `.exit.text' debugging?
Thread-Index: Acky8l/H5KFAovgZR72QDlHz1FIOrA==
References: <Pine.LNX.4.64.0810202207140.23258@anakin>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: "Linux Kernel Development" <linux-kernel@vger.kernel.org>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Geert Uytterhoeven wrote:

> Last night I got these in my build logs:
>
> | `.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> | `.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
>
> i.e. not much context. Is there an easy way to find out who's the
> offender?
>
> Thx!
>
> Gr{oetje,eeting}s,
>
> 						Geert
>

Look in .built-in.o.cmd for the files included in that object
file. It's a start. Something like

../drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c

With an exit(EX_SOFTWARE) or similar that was not supposed to
be included in the kernel build because it is for user-mode
build code.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.25.17 on an i686 machine (4787.24 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged. Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited. If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
