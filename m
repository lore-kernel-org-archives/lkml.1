Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbZCWVac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbZCWVac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 17:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756741AbZCWVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 17:30:23 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:64883 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756657AbZCWVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 17:30:22 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: avoid PM error messages during resume if a device was disconnected
Date: Mon, 23 Mar 2009 22:30:18 +0100
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903232211.51154.elendil@planet.nl>
In-Reply-To: <200903232211.51154.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232230.19330.elendil@planet.nl>
X-OriginalArrivalTime: 23 Mar 2009 21:30:20.0195 (UTC) FILETIME=[91253F30:01C9ABFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009, Frans Pop wrote:
> Currently if a laptop is suspended e.g. while docked and then resumed
> after undocking it, the following errors get generated because the USB
> hub in the docking station and the devices connected to it are no
> longer available:
> pm_op(): usb_dev_resume+0x0/0x10 returns -19 
> PM: Device 1-2 failed to resume: error -19
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2.2 failed to resume: error -19
> pm_op(): usb_dev_resume+0x0/0x10 returns -19
> PM: Device 1-2.3 failed to resume: error -19
>
> As the removal of USB devices while a system is suspended is a
> relatively common use case and in most cases not an error, just return
> success on -ENODEV. The user gets informed anyway as the USB subsystem
> generates regular disconnect messages for the devices shortly
> afterwards:
> usb 1-2: USB disconnect, address 3 
> usb 1-2.2: USB disconnect, address 4
> usblp0: removed
> usb 1-2.3: USB disconnect, address 5
>
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>

Forgot to mention that the patch is intended on top of Rafael's "Rework 
disabling of interrupts during suspend-resume" series.
