Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbXLIF7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbXLIF7z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 00:59:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXLIF7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 00:59:45 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:33640 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbXLIF7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 00:59:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uid8O7xmg1zNZOq2wE+ZODWntPbQ05s9IpqTdTa38xPZ2vvnDv96vXKgiYIzyHzcZ2/C6HivyMsHm8pbhl2vf+oRDQwpUTaxcmRxnhicW7RURF6JT4/oZkNrrNaBRA5UuuQ3SIf4JA6gMKMe7KAQDLyhtmdPT3zsJbHifp9GONk=
Message-ID: <475B8446.4010300@gmail.com>
Date: Sun, 09 Dec 2007 14:59:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andreas Mohr <andi@lisas.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-ide@vger.kernel.org,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <fa.qQhD8aJpiTOFaZqjRYwoaG7YT1c@ifi.uio.no> <fa.yaP86AixGhz5Q7eXSu04pIQp6ho@ifi.uio.no> <fa.c3k8VKWAx4HIo9zXWbL5Ek0oSBw@ifi.uio.no> <fa.C8ACnOhs8bXB++vmugf5F34JcJg@ifi.uio.no> <fa.5o6E6S0UWnARbQPxLe30TvLQIiY@ifi.uio.no> <475AE150.9050306@shaw.ca>
In-Reply-To: <475AE150.9050306@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Matthew Garrett wrote:
>> On Sat, Dec 08, 2007 at 02:20:01AM -0800, Andrew Morton wrote:
>>> On Sat, 8 Dec 2007 11:12:57 +0100 Andreas Mohr <andi@lisas.de> wrote:
>>>> ACPI Exception (exoparg2-0442): AE_AML_PACKAGE_LIMIT, Index
>>>> (0FFFFFFFF) is beyond end of object [20070126]
>>>> ACPI Error (psparse-0537): Method parse/execution failed
>>>> [\_SB_.PCI0.IDE0.GTF_] (Node c180b990), AE_AML_PACKAGE_LIMIT
>>>> ACPI Error (psparse-0537): Method parse/execution failed
>>>> [\_SB_.PCI0.IDE0.CHN0.DRV1._GTF] (Node c180b888), AE_AML_PACKAGE_LIMIT
>>>> ata1.01: _GTF evaluation failed (AE 0x300d)
>>
>> 037f6bb79f753c014bc84bca0de9bf98bb5ab169 ought to have fixed this?
>>
> 
> I should think it should have.
> 
> I think we're too aggressive about disabling the libata ACPI support,
> even. One of my laptop's _GTF commands on resume is a DEVICE
> CONFIGURATION FREEZE LOCK command, which gets rejected by the drive
> (maybe it worked on the original Hitachi disk, but I've upgraded it to a
>  newer Samsung). I'd say if the drive returns command aborted on one of
> these, we should just ignore that command and continue to the next one
> without trying to retry or disabling the ACPI support entirely.

Yeap, my pending patchset does exactly that.  It's currently being
tested by but reporters.  I'll soon post the patchset.

Thanks.

-- 
tejun
