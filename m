Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZBFAdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZBFAdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbZBFAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:33:18 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:11592 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZBFAdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:33:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=HOC8QkD9XVPpbyszPId+5f9YAhyr7signrhxXupTM1lS4TY+XPiuT3N1dDmvTvR3NQ
         pAZTORYMt21eRZxKzInN9H4WaiwWpJUyJqNp1QiGkYqTzeuKh9AEk/kz/wJsiDPONg97
         wxIduBqZ8MMQjy+5PnBcE1udFms4XzvEHVaLw=
Message-ID: <498B8547.1010803@gmail.com>
Date: Thu, 05 Feb 2009 18:33:11 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel
To: Ben Greear <greearb@candelatech.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, len.brown@intel.com,
       NetDev <netdev@vger.kernel.org>
Subject: Re: Regression on VIA C3 motherboard, commit: 66f2173e2
References: <498A93E5.2080509@candelatech.com>
In-Reply-To: <498A93E5.2080509@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Greear wrote:
> I have a via motherboard with C3 processor and some real-tek NICs.  I 
> noticed
> when using the top-of-tree that performance on it sucked (30Mbps v/s 54Mbps
> network throughput in one pertinent test).
> 
> After several hours of bisecting, I see this as the culprit:
> 
> 7b37b5fd9ba32c0c5afc3537eed7e7466f2173e2 is first bad commit
> commit 7b37b5fd9ba32c0c5afc3537eed7e7466f2173e2
> Author: Len Brown <len.brown@intel.com>
> Date:   Tue Dec 23 01:47:42 2008 -0500
> 
>    ACPI: disable MPS when NO APIC-table found
>      When ACPI is asked to find an MADT (APIC table)
>    and fails, then ACPI expects to run in PIC mode.
>      However, if an MP Table is was found, IRQs will be
>    registered as if an IOAPIC is being used, even
>    though ACPI is configuring interrupt links links for PIC mode.
>      In this scenario, disable MPS so that IRQs
>    are registered in PIC mode, consistent with ACPI.
>      http://bugzilla.kernel.org/show_bug.cgi?id=12257
>      Signed-off-by: Len Brown <len.brown@intel.com>
> 
> :040000 040000 86ce74daee3a9fe6ff21ef7f8fb364af23ec0c1e 
> 364933dfec0df34e63b1aeff6aff4092d421886b M      arch
> 
> 
> In addition, I see this warning in my logs, which is likely the symptom:
> 
> ACPI Exception (tbxface-0627): AE_NO_ACPI_TABLES, While loading 
> namespace from ACPI tables ]
> ACPI: Unable to load the System Description Tables

You're getting this on boot:

ACPI Error (tbxfroot-0218): A valid RSDP was not found [20080926]

That essentially means ACPI isn't working at all, I think. Did previous 
kernels produce this error? Do you have ACPI disabled in the BIOS or 
something?
