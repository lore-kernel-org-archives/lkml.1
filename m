Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbXEGJlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbXEGJlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 05:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754267AbXEGJlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 05:41:05 -0400
Received: from otello.alma.unibo.it ([137.204.24.163]:40335 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbXEGJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 05:41:04 -0400
X-Greylist: delayed 1858 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 05:41:04 EDT
Message-ID: <463EED3F.9080106@otello.alma.unibo.it>
Date: Mon, 07 May 2007 11:11:27 +0200
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.0 (X11/20070423)
MIME-Version: 1.0
To: Paul Fulghum <paulkf@microgate.com>
Cc: linux-kernel@vger.kernel.org, linux-usb-users@lists.sourceforge.net
Subject: Re: [Linux-usb-users] [SOLVED] Serial buffer corruption [was Re:
 FTDI usb-serial possible bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>		<1178381287.3379.8.camel@x2>		<20070505173647.544f6707@the-village.bc.nu>		<200705052007.16742.oliver@neukum.org>		<20070505225241.54a5d01d@the-village.bc.nu>	<5486cca80705060029p433c6acar22faaeced2d7da37@mail.gmail.com> <463DE7CF.5010400@microgate.com>
In-Reply-To: <463DE7CF.5010400@microgate.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum ha scritto:
> There is no one policy here that will make everyone happy.
> Some will want all the data before some was lost,
> others the data after some was lost.
IMVHO the only sane thing is ALWAYS avoid "holes" (some old data, then
the "hole" of lost data, then some new data) after a flush().
HW buffers (and buffers on the remote end) are not an issue: they
contain fresher data (usually in "sliding window" mode) than buffered.

Thinking with a 300bps modem (anybody else remembers such an ancient
thing?):
- Sender have to transmit the alphabet;
- On the sender's modem there's a 4 char buffer
- On the receiver's modem there's another 4 char buffer
- The receiver's driver have another 4 char buffer

If the receiver issues a flush() after reading 'C', then the next read()
should return FGHIJKL...Z (or anything IN SEQUENCE), but *NEVER* DEFGKLM
(skipped H,I and J).

BYtE,
 Diego.
