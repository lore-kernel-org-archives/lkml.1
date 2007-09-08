Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbXIHV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbXIHV3S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 17:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXIHV3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 17:29:05 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:44582 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753170AbXIHV3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 17:29:04 -0400
Message-ID: <46E30F24.3060604@trn.iki.fi>
Date: Sun, 09 Sep 2007 00:07:48 +0300
From: =?ISO-8859-1?Q?Lasse_K=E4rkk=E4inen?= <tronic+1kf5@trn.iki.fi>
User-Agent: Thunderbird 2.0.0.6 (X11/20070824)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-usb-devel@lists.sourceforge.net
Subject: Re: 2.6.23-rc3 USB segfaults + urb status -32
References: <46D0974B.5030806@trn.iki.fi> <6bffcb0e0708281614m74de5beai2778395cb13a90e7@mail.gmail.com>
In-Reply-To: <6bffcb0e0708281614m74de5beai2778395cb13a90e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about late reply. I have been extremely busy with other things.

> Does 2.6.22 work fine?

Not perfect, but it does not crash spontaneously. I have been running
2.6.22-ck1 since my last email with only one crash and today I have
tortured 2.6.22.5 as badly as I can (switching bConfigurationValue of
the sound card, unplugging USB devices on fly, doing heavy I/O, etc),
without crashes.

However, with 2.6.23-rc5 I still got segfaults on boot¹ (log1), a few
dozen urb status -32 messages by powering off the sound card while it
was in use (log2), but no crashes there. It did finally crash (log3),
though, after about three hours of coding + listening to music on text
console (no Nvidia drivers nor any other external modules). Apparently
it reset all USB buses, including the one that my system disk is
connected to (there is nothing else on the same port), effectively
killing the system, even though technically it didn't crash.

It also seems that .23-rc5 no longer exposes bConfigurationValue and a
few other settings under /sys/bus/usb/devices/*/, so I couldn't test if
switching the bConfigurationValue of the sound card still causes
crashes² there (it has been a reliable way to do that in the past).

I could not reproduce the excessive log flood of urb status -32,
mentioned in my original message.

The logs are here:
http://delenn.homelinux.net/kernel-usb/

¹) I gather that usb_id is something related to udev. It does not crash
with .22 kernels, only with the .23 series.
²) OOPSes, to be specific, IIRC.

