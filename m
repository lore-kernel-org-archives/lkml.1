Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZCUAoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZCUAoT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 20:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZCUAoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 20:44:01 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:37625 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbZCUAoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 20:44:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=XXIPf3DZprAG6xD8BiuY1c4OAexVn8It5RGt/8nWicKIYnrEtVYfoTyfJJ69baUXTE
         lY864n9GnKpg6bJsvTlP3R4ZKMa3RG3prbArFscFDRasKruQe1k0dPF33A8x0qGsGS/T
         NddQr5ph+aC+KYZ0cKRoqblKu9jCPBeG02kmg=
Message-ID: <49C4384A.5030802@gmail.com>
Date: Fri, 20 Mar 2009 18:43:54 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Christopher Schramm <debian@shakaweb.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: APIC problem report
References: <49C1FE7D.9070605@shakaweb.org>
In-Reply-To: <49C1FE7D.9070605@shakaweb.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christopher Schramm wrote:
> Hi,
> 
> I found a problem with APIC on a desktop PC equipped with Asus' M2N, 
> running the manufacturer's AMI BIOS - version 0803.
> 
> I've tried booting Knoppix 5.3.1 (Kernel 2.6.24.4) and GParted live 
> (Debian's 2.6.26-13). Both will only boot if noapic parameter is used.
> Otherwise I get "MP-BIOS bug: 8254 timer not connected to IO-APIC" 
> resulting in a kernel panic.
> 
> apic=debug gives "ACPI: Core revision 20080321", "Version 80050010" 
> (twice), "ID: 0", "LVT0: 700", "LVT1:400" and "ESR value before enabling 
> vector: 0x00000004  after: 0x00000000".
> 
> Hope it's of some use (and the best place to report it)
> 
> Christopher

Try booting with acpi_use_timer_override kernel parameter. The problem 
is likely the same one that shows up on my Asus A8N-SLI Deluxe with the 
latest 1805 BIOS. The kernel ignores ACPI timer overrides on NVIDIA 
chipsets since they have historically been broken, however in later BIOS 
versions this has been fixed and the override is now apparently required 
for the 8254 timer to function properly through the IO-APIC.

That problem is still there in newer kernels, but it's not fatal since 
the kernel just routes the timer through the PIC instead..
