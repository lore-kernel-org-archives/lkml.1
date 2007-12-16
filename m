Return-Path: <linux-kernel-owner+w=401wt.eu-S1765330AbXLPX3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765330AbXLPX3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 18:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760975AbXLPX3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 18:29:07 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34596 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759853AbXLPX3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 18:29:06 -0500
Date: Mon, 17 Dec 2007 00:29:04 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Harald Dunkel <harald.dunkel@t-online.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: howto get a melodic system beep?
In-Reply-To: <Pine.LNX.4.64.0712162337460.32270@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0712170020280.32270@fbirervta.pbzchgretzou.qr>
References: <4765A5ED.60605@t-online.de> <Pine.LNX.4.64.0712162337460.32270@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 16 2007 23:37, Jan Engelhardt wrote:
>On Dec 16 2007 23:25, Harald Dunkel wrote:
>>
>> Hi folks,
>>
>> Is there a way to replace the system beep by something more
>> melodic?
>>
>> I remember some 10 years ago there was a patch for the kernel
>> to call an external "beep daemon" playing an audio file instead
>> (no kidding). But it never worked very well. Sometimes there
>> was a huge delay, and some programs were not very nice to the
>> system beep.
>>
>> My X-mas wish would be to get an improvement here.

In drivers/input/misc/pcspkr.c, pcspkr_event() in the SND_BELL case,
you could add a reroute so that SND_BELL events are passed to
userspace (think /dev/input/pcspkr). Delays are of course possible,
and it really depends on how the scheduler does its job (read: you
might want to renice your userspace part).
