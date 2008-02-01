Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbYBAJRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbYBAJRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbYBAJRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:17:13 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37996 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755810AbYBAJRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:17:07 -0500
X-Sasl-enc: 0GWf2SWq17sn8nhu7iQOJMmhstxkpMBT5K1GrcTBQioQ 1201856061
Message-ID: <47A2DEAC.7000004@ladisch.de>
Date: Fri, 01 Feb 2008 09:56:12 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
CC: list linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23.14 snd_hda_intel problem
References: <47A25998.1000501@eyal.emu.id.au>
In-Reply-To: <47A25998.1000501@eyal.emu.id.au>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eyal Lebedinsky wrote:
> A recent update to 2.6.23.14-64.fc7 lost sound. The boot log now has
> 	hda-intel: Error creating card!
> 	HDA Intel: probe of 0000:00:1b.0 failed with error -12

The two lines before:
| usbcore: registered new interface driver snd-usb-audio
| cannot find the slot for index 0 (range 0-0), error: -16

... show that a USB audio device was loaded as the first card (at
index 0), and that the HDA device doesn't load because it tries to go
to the same index.

Use the sound card configuration utility of your distribution to
configure the USB audio device to be the second device, or add the line
  options snd-usb-audio index=1
to /etc/modprobe.conf.


HTH
Clemens
