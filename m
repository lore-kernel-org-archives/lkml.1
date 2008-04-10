Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYDJMER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYDJMER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbYDJMEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:04:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:42135 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227AbYDJMEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UG0PKuH3ulSIAX7Lz4iriRwf7Vph/u5R0m0gGBx1szkTstUb1GFDSt5uTHCyxegMHPuLcdNr9DiCm+PYZzVf2Jr2b/inLLvhhXIO9Dc7yNWnaQSORCAcgsvXqM921bv6ok9w1hYpAmkp7Wex+QyqFax5Yusv7M2LN6I9SGgd9yQ=
Message-ID: <58cb370e0804100503u71014cdend6425efe14b8d88c@mail.gmail.com>
Date: Thu, 10 Apr 2008 14:03:59 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG] linux-next: Tree for April 10 - kernel panic while loading ata driver on powermac
Cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <47FDEAFA.10407@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080410181404.b76939a6.sfr@canb.auug.org.au>
	 <47FDEAFA.10407@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Apr 10, 2008 at 12:24 PM, Kamalesh Babulal
<kamalesh@linux.vnet.ibm.com> wrote:
> Hi Stephen,
>
>  The next-20080410 kernel panics while bootup over the PowerMac G5 box, while
>  loading the ATA driver.
>
>  [    3.704000] Faulting instruction address: 0xc0000000000222a8
>  [    3.704000] Oops: Kernel access of bad area, sig: 11 [#1]
>  [    3.704000] SMP NR_CPUS=32 NUMA PowerMac
>  [    3.704000] Modules linked in:
>  [    3.704000] NIP: c0000000000222a8 LR: c00000000021cd10 CTR: 0000000000000100
>  [    3.704000] REGS: c0000002760db070 TRAP: 0300   Not tainted  (2.6.25-rc8-next-20080410-autokern1)
>  [    3.704000] MSR: 9000000000009032 <EE,ME,IR,DR>  CR: 44000042  XER: 20000000
>  [    3.704000] DAR: a0001000822fa000, DSISR: 0000000040000000
>  [    3.704000] TASK = c0000002760d7100[1] 'swapper' THREAD: c0000002760d8000 CPU: 0
>  [    3.704000] GPR00: 0000000000000100 c0000002760db2f0 c000000000498310 a0001000822fa000
>  [    3.704000] GPR04: c000000274806a00 0000000000000100 0000000000000201 c00000000000fed4
>  [    3.704000] GPR08: c0000002760daf20 c0000000003ee0d8 c0000000004f1428 0000000000000000
>  [    3.704000] GPR12: 0000000000000000 c0000000003fa700 0000000000000000 0000000000000000
>  [    3.704000] GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  [    3.704000] GPR20: 0000000000000001 0000000000000027 0000000000000027 0000000000000000
>  [    3.704000] GPR24: c0000000004f1400 0000000000000000 0000000000000201 c0000000004f1490
>  [    3.704000] GPR28: a0001000822fa000 0000000000000200 c00000000044cf50 c000000274806a00
>  [    3.704000] NIP [c0000000000222a8] ._insw_ns+0x10/0x30
>  [    3.704000] LR [c00000000021cd10] .ata_input_data+0x1f4/0x264

Could you please add printk() for 'hwif->host_flags', 'mmio' and 'io_32bit'
to ide-iops.c::ata_input_data() so we know more on what is going on?

Thanks,
Bart
