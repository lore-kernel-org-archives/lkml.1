Return-Path: <linux-kernel-owner+w=401wt.eu-S1752746AbZHPQ7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbZHPQ7y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 12:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZHPQ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 12:59:53 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:5889 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZHPQ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 12:59:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UHjFIoZpgxvYXuatmMAsXJMTopRarnRDY7FOIR0gG4EuuhW69QRIkAcOwcc7yH5Rgt
         AB1Sj5kJAeYXIoW4HG44D9MYW/VmWLbIDmhkULIPG47qA2FRywc3R5gMXKne0E8PMFNJ
         f3AtEyg95Q+/fFw3EE4ad7XVToaQL0qIA3ows=
Message-ID: <4A883943.5050508@gmail.com>
Date: Sun, 16 Aug 2009 10:52:19 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Daniel J Blueman <daniel.blueman@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.31-rc6] ACPI region conflict regression...
References: <6278d2220908160259v38c34c4ck6db2853ae886492@mail.gmail.com>
In-Reply-To: <6278d2220908160259v38c34c4ck6db2853ae886492@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2009 03:59 AM, Daniel J Blueman wrote:
> When booting 2.6.31-rc6 on some x86-64 hardware with fan control and
> monitoring via the Winbond 83627 chip, 2.6.31-rc6 prevents the module
> using an I/O region [1] described in the ACPI DSDT table [2] - which
> didn't occur in -rc5.
>
> Is there a way to relax this, or does it require adding
> acpi_bus_register_driver(struct acpi_driver) and the needed code this
> late in the game?
>
> Thanks,
>    Daniel
>
> --- [1]
>
> w83627ehf: Found W83627EHG chip at 0x290
> ACPI: I/O resource w83627ehf [0x295-0x296] conflicts with ACPI region
> SEN1 [0x295-0x296]
> ACPI: Device needs an ACPI driver

This is only a warning, it doesn't prevent reserving the region by 
default, does it?

>
> --- [2]
>
>      OperationRegion (SEN1, SystemIO, 0x0295, 0x02)
>      Field (SEN1, ByteAcc, NoLock, Preserve)
>      {
>          SEI0,   8,
>          SED0,   8
>      }

