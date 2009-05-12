Return-Path: <linux-kernel-owner+w=401wt.eu-S1759736AbZELXer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759736AbZELXer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 19:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758081AbZELX2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 19:28:06 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48113 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbZELX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 19:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ts6XiNmXZiDC278V8vJzlYeXKJFeU5QkierdHnGELQMIgbNlfuNNDK1GXwnBFAVb4m
         ii1c5f+zGXXKTdmy04To6G17Jf1sn/v10Rke7IPVpE2A2kLJYJz81AnveWm5b/eeE2XM
         QmVMiU4zoNbWy6AltW9gBqPxNfSmG+Cnb1/2A=
Message-ID: <4A0A05FC.10906@gmail.com>
Date: Tue, 12 May 2009 17:27:56 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mats Erik Andersson <mats.andersson@gisladisker.se>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 1/1] pci: expose SMBus on Asus notebook A6L
References: <20090512100523.GA31131@mea.homelinux.org>
In-Reply-To: <20090512100523.GA31131@mea.homelinux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mats Erik Andersson wrote:
> From: Mats Erik Andersson <mats.andersson@gisladisker.se>
> 
> Addition of one unknown subsystem identifier to the
> quirks handler for chipset i82855GM_HB on notebook
> Asus A6L. This exposes the otherwise hidden SMBus
> controller within the south bridge ICH4-M.
> 
> Signed-off-by: Mats Erik Andersson <mats.andersson@gisladisker.se>
> ---
> 
> Tried and successfully used on kernel 2.6.29 and 2.6.23.17.
> 
> --- drivers/pci/quirks.c.orig	2009-05-09 00:47:21.000000000 +0200
> +++ drivers/pci/quirks.c	2009-05-12 11:20:04.000000000 +0200
> @@ -1068,8 +1068,9 @@ static void __init asus_hides_smbus_host
>  		else if (dev->device == PCI_DEVICE_ID_INTEL_82855GM_HB)
>  			switch (dev->subsystem_device) {
>  			case 0x1751: /* M2N notebook */
>  			case 0x1821: /* M5N notebook */
> +			case 0x1897: /* A6L notebook */
>  				asus_hides_smbus = 1;
>  			}
>  		else if (dev->device == PCI_DEVICE_ID_INTEL_82855PM_HB)
>  			switch (dev->subsystem_device) {

This has to be done with caution. If the BIOS accesses the SMBus 
controller from ACPI AML code or SMI code, then allowing a Linux driver 
to access the controller may cause problems.
