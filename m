Return-Path: <linux-kernel-owner+w=401wt.eu-S938505AbXHIJgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938505AbXHIJgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 05:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbXHIJfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 05:35:51 -0400
Received: from antonio.urjc.es ([193.147.184.24]:40847 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXHIJfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 05:35:50 -0400
Message-ID: <46BAE005.4000906@urjc.es>
Date: Thu, 09 Aug 2007 11:36:05 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       GregKH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
References: <46B37CF7.2020803@urjc.es><20070806142451.5d28d41c@gondolin.boeb
		lingen.de.ibm.com><46B7832B.6010808@urjc.es><20070807125844.4d756b04@gondo
			l	in.boeblingen.de.ibm.com><3ae72650708070446y6452d13jb7cd802119dab3ce@ma
	il	 
	.gmail.com><20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com><46B869	
	C6.3090708@urjc.es><1186491472.3611.33.camel@lov.localdomain><46B87ACA.7010
	501@urjc.es> <20070807162618.3814ff78@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070807162618.3814ff78@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Thu, 09 Aug 2007 
	11:35:43 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-7.3028 TC:1F TRN:31 TV:3.6.1039(15350.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Cornelia Huck wrote:

> So it is indeed that this driver wants to fail its probe if it
> cannot get the firmware.

That's right. The driver unbinds itself from the device if it doesn't
get the firmware.

> A possibilty to achieve a similar effect would be to use
> request_firmware_nowait() and to call device_release_driver() from
> the callback if no firmware is loaded. (This would imply a split of
> that driver's probe function into two stages.)

The comments in the source code say that request_firmware_nowait()
is an "asynchronous version of request_firmware() for contexts where
it is not possible to sleep". So a driver's decision to call one of
them is not based on whether it wants to wait or not, but whether it
_can_ wait.

Of course, it can be decided that we never want to wait, but then
the best course of action would be to make request_firmware itself
behave as request_firmware_nowait (no need to change drivers).

Anyway, my point is that it is useless to have the kernel block for
a minute at boot waiting for something that cannot happen, and that
it should be avoided (even if my proposed solution is not the way
to go).

Javier


