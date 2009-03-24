Return-Path: <linux-kernel-owner+w=401wt.eu-S1751958AbZCXFnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958AbZCXFnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 01:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZCXFnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 01:43:13 -0400
Received: from mail-gx0-f208.google.com ([209.85.217.208]:42108 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZCXFnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:43:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=TIcUMTh5UGTBIMOueg9I2b9lemUCUjUXmvdpVE1d3HRoqHqAtZC+sRIsWBaCe1cmmz
         LkE5Y4ILr1Jze4gI5B6EICRLhyZnQc5Bs+yp2VVZfvRwg4y2XBXTp6T+aEU3QK7lvaQc
         fC8kVoPOQVkSnlSYBN1NU9g/wwvtF3sP9qiSE=
Message-ID: <49C872EA.4010304@gmail.com>
Date: Mon, 23 Mar 2009 23:43:06 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: justinmattock@gmail.com
CC: linux-kernel@vger.kernel.org
Subject: Re: ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts with
 ACPI   region SMBI [0xefa0-0xefaf]
References: <alpine.LNX.2.00.0903230150110.2409@havk>
In-Reply-To: <alpine.LNX.2.00.0903230150110.2409@havk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

justinmattock@gmail.com wrote:
> 
> Any suggestions on what this might be:
> (dmesg):
> 
> [    6.940280] power_supply ADP1: 1 dynamic props
> [    6.940283] power_supply ADP1: prop ONLINE=1
> [    6.940340] input: Sleep Button (CM) as 
> /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input5
> [    6.968564] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) 
> -> IRQ 19
> [    6.977814] ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts 
> with ACPI region SMBI [0xefa0-0xefaf]
> [    6.987218] ACPI: Device needs an ACPI driver

It means the i801_smbus driver is using an I/O resource range that BIOS 
ACPI code may be using. The warning is there because in some cases this 
can cause problems, i.e. if the native driver and ACPI AML code try to 
access the device at the same time in a conflicting fashion.

> [    7.000114] ath9k: 0.1
> [    7.000163] ACPI: Sleep Button (CM) [SLPB]
> [    7.018052] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> 
> IRQ 17
> [    7.027094] ath9k 0000:03:00.0: setting latency timer to 64
> 
> either i801_smbus(to me) is the issue, or it's something else.
> 
> any ideas?
> 
> -- Justin P. Mattock

