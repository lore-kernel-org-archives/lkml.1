Return-Path: <linux-kernel-owner+w=401wt.eu-S1756992AbYCaSFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbYCaSFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:05:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYCaSFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:05:41 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:43685 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbYCaSFk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:05:40 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Mark Lord <lkml@rtr.ca>
Subject: Re: 2.6.25-rc7:  Ugh.
Date: Mon, 31 Mar 2008 20:05:37 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Pavel Machek <pavel@suse.cz>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jikos@suse.cz
References: <47EBBD57.30902@rtr.ca> <47F11D8F.4020209@rtr.ca> <47F11FC6.8010701@rtr.ca>
In-Reply-To: <47F11FC6.8010701@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200803312005.37804.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 31. März 2008 19:30:46 schrieb Mark Lord:
> I've now removed the internal USB-Bluetooth adaptor, so we can now test
> without any USB devices connected.
> 
> Suspend without any USB devices plugged-in, and it *always* resumes fine
> with working USB, even when the USB stuff is plugged in before hitting
> the resume button.

To the USB subsystem these devices are plugged in as soon as power is
returned.

> But suspend *with* any USB device plugged-in, and it *always* fails resume,
> even when the USB device is unplugged before hitting the resume button.
> 
> Conclusion:   the bug is in the usb SUSPEND code, not the RESUME code.

I would arrive at the opposite conclusion. Independent from that, loss of
power is not really supported by USB during STR. Obviously it should not
hang, but all devices will be disconnected and reconnected.

But if power is cut with newer kernels and older kernels retain it, something
must have changed. Can you undo the ACPI changes since the last working
kernel?

	Regards
		Oliver

