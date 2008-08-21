Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYHUFSL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYHUFSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:18:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYHUFRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:17:55 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:37307 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbYHUFRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:17:54 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: amruth_pv@yahoo.com
Subject: Re: USB Serial device disconnect causes IRQ disable
Date: Thu, 21 Aug 2008 07:19:03 +0200
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <681979.61508.qm@web45205.mail.sp1.yahoo.com>
In-Reply-To: <681979.61508.qm@web45205.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808210719.03925.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 21 August 2008 02:18:37 schrieb amruth:
> Hi
> I don't have any driver modules. I have everything built into kernel.
> When can this kind of IRQ disable happen, what causes this. The issue happened because of hotplugging my device but the device works fine.
> usb_register(driver) might have caused the issue. How do we debug this problem.

What happens when you never plug in the device?
I think you have another device causing interrupts whose driver
doesn't handle them. While the usb host controller is busy due
to your device, it generates enough interrupts to keep the logic
for detection of spurious interrupts happy. When you unplug your
device you get too many unhandled interrupts.

	Regards
		Oliver
