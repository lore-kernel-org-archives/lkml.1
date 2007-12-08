Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbXLHSZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbXLHSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751230AbXLHSZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:25:11 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:9156 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbXLHSZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:25:08 -0500
Date: Sat, 08 Dec 2007 12:24:16 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
In-reply-to: <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andreas Mohr <andi@lisas.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Len Brown <lenb@kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <475AE150.9050306@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no>
 <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no>
 <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no>
 <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no>
 <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Sat, Dec 08, 2007 at 02:20:01AM -0800, Andrew Morton wrote:
>> On Sat, 8 Dec 2007 11:12:57 +0100 Andreas Mohr <andi@lisas.de> wrote:
>>> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index (0FFFFFFFF) is beyond end of object [20070126]
>>> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
>>> ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE0.CHN0.DRV1._GTF] (Node c180b888), AE_AML_PACKAGE_LIMIT
>>> ata1.01: _GTF evaluation failed (AE 0x300d)
> 
> 037f6bb79f753c014bc84bca0de9bf98bb5ab169 ought to have fixed this?
> 

I should think it should have.

I think we're too aggressive about disabling the libata ACPI support, 
even. One of my laptop's _GTF commands on resume is a DEVICE 
CONFIGURATION FREEZE LOCK command, which gets rejected by the drive 
(maybe it worked on the original Hitachi disk, but I've upgraded it to a 
  newer Samsung). I'd say if the drive returns command aborted on one of 
these, we should just ignore that command and continue to the next one 
without trying to retry or disabling the ACPI support entirely.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

