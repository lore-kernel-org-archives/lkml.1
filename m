Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZBQOah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZBQOah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZBQOa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:30:29 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:60780 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbZBQOa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:30:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xqCfJVgmc7t5gSwDemyxZiiD7ghDwyXrcc45TIzjCf9DNSjaOpRE6vd/iQCX8voN0m
         bInZlgkN/Mz2m9XxAwuQa9lboKCFvpKnDTRSBVvVdheS582sCc3fqV9LR3rIvklmLhTf
         S/iQGDnVA0m3xATMbBRGf5cKRwHx5xE9cbJAw=
Message-ID: <499AC9FF.8040605@tuffmail.co.uk>
Date: Tue, 17 Feb 2009 14:30:23 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Sitsofe Wheeler <sitsofe@yahoo.com>
CC: linux-kernel@vger.kernel.org, corentincj@iksaif.net,
       acpi4asus-user@lists.sourceforge.net
Subject: Re: EeePC card reader activated after suspend to ram
References: <20090217135857.GA2854@silver.sucs.org>
In-Reply-To: <20090217135857.GA2854@silver.sucs.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sitsofe Wheeler wrote:
> Hi,
>
> I've found that there is a particular circumstance when the card reader
> in my EeePC 900 will always be activated on resume even though before
> the suspend to ram it was switched off.
>
> The steps to reproduce are as follows:
>
> 1. Ensure the card reader is enabled before Linux boots (e.g. if Linux
> is already running do (as root)
> echo 1 > /sys/devices/platform/eeepc/cardr
> and then reboot).
> 2. In the freshly booted kernel issue (as root)
> echo 0 > /sys/devices/platform/eeepc/cardr
> 3. Initiate suspend to RAM e.g.:
> echo mem > /sys/power/state 
> 4. Press a key to resume.
>
> Notice that the logs will contain something similar to the following:
>
> kernel: [  841.435629] Restarting tasks ... done.
> kernel: [  907.576216] usb 1-5: new high speed USB device using ehci_hcd and address 3
> kernel: [  907.699381] usb 1-5: configuration #1 chosen from 1 choice
> kernel: [  907.707460] scsi3 : SCSI emulation for USB Mass Storage devices
>
> Doing
> cat /sys/devices/platform/eeepc/cardr
> returns 0. Issuing
> echo 0 > /sys/devices/platform/eeepc/cardr
> even though the card reader is supposedly off will result in it being
> disabled until after the next suspend to ram/resume.
>
> Reproduced with a clean 2.6.29rc5 and the heavily Xandros patched
> Xandros 2.6.21 kernel that the Eee ships with.
>
> Does anyone have any ideas about this one?
>   

It happens on my 701 too. The driver doesn't explicitly cache the
"cardr" value, so I'd blame the BIOS.

You could work around it. Add a hack somewhere that does the equivalent of

x=`cat /sys/devices/platform/eeepc/cardr`
echo $x > /sys/devices/platform/eeepc/cardr

But it is a tradeoff. This is a largely unused feature. You've found one
pretty harmless bug in the hardware... there's the risk that there's
another hardware bug which would then be easier to trigger, and cause
bigger problems. It'd be much better if Asus could fix the BIOS :-).

Alan

