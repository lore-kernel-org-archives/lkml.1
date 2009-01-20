Return-Path: <linux-kernel-owner+w=401wt.eu-S1761476AbZATNHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761476AbZATNHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 08:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZATNHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 08:07:24 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:51960 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516AbZATNHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 08:07:23 -0500
MIME-Version: 1.0
In-Reply-To: <200901201349.33707.ionut.leonte@gmail.com>
References: <200901201349.33707.ionut.leonte@gmail.com>
Date: Tue, 20 Jan 2009 14:07:21 +0100
Message-ID: <ac3eb2510901200507p4b107af6ud87a634af6679223@mail.gmail.com>
Subject: Re: 2.6.28 changes in-kernel name for UVC device ?
From: Kay Sievers <kay.sievers@vrfy.org>
To: Ionut Leonte <ionut.leonte@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 12:49, Ionut Leonte <ionut.leonte@gmail.com> wrote:
> I have a Dell laptop with an integrated webcam which works with the 'uvcvideo'
> module. For kernel versions 2.6.27 and below the following udev rule:
>
>   KERNEL=="video[0-9]*",  NAME="v4l/video%n", SYMLINK+="%k", GROUP="video"
>
> would create '/dev/video0' as a link to '/dev/v4l/video0'. When switching to
> 2.6.28 the rule creates '/dev/video1394-0' instead. Obviously most user-space
> apps were quite surprised by this (as was I).
>
> Is this change intended or is it the accidental result of some modification ?

These rules are broken, and match also on firewire devices and not
only video4linux devices.

Such rules are not part of the standard udev setup and need to be
fixed to work as intended. There is no change or fault at the kernel
side. You may just disable the firefire drivers if you don't need
them.

Btw, swapping default kernel names to devfs names and create symlinks
for the kernel names is not recommended at all.

Kay
