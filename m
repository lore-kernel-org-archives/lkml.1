Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXBRQT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXBRQT3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:19:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXBRQT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:19:29 -0500
Received: from smtp-100-sunday.noc.nerim.net ([62.4.17.100]:3657 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751385AbXBRQT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:19:28 -0500
Date: Sun, 18 Feb 2007 17:19:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dax Kelson <dax@gurulabs.com>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linus' laptop and Num lock status
Message-Id: <20070218171940.68a4c44d.khali@linux-fr.org>
In-Reply-To: <Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
References: <1171479361.3706.48.camel@mentorng.gurulabs.com>
	<Pine.LNX.4.64.0702141104210.3604@woody.linux-foundation.org>
	<20070214202144.1ddb930f.khali@linux-fr.org>
	<Pine.LNX.4.64.0702141130340.20368@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, 14 Feb 2007 11:32:34 -0800 (PST), Linus Torvalds wrote:
> On Wed, 14 Feb 2007, Jean Delvare wrote:
> > On x86, the BIOS led state can be read from byte 0x97 the BIOS RAM. The
> > BIOS RAM is mapped at 0x400 so all we need to do is to one byte from
> > RAM (offset 0x497). This is how Suse's hwinfo does.
> 
> Heh. Shows just how much I ever used DOS and BIOS.

Well, I didn't know about it either before I was told about how hwinfo
was able to retrieve the information.

> > But maybe the first question to ask is: why is the BIOS setting lost in
> > the first place? Why is the kernel resetting the led state?
> 
> Ehh. Silly question. "Those flags, they do nothing."
> 
> The kernel needs to know what they are in order to react correctly to 
> them. And since you can't read them from hardware, the only way to know 
> what they are (if you don't know about BIOS magic areas) is to SET THEM.
> 
> Which is what the kernel has traditionally always done.

OK, it makes sense, thanks for clarifying this point.

Would it be acceptable to add some code in the kernel to read the
settings from the BIOS where possible, and have the kernel write these
settings rather than the default "all LEDs disabled"?

The problem is that I don't know how we can know for sure whether there
is BIOS RAM to read from, or not. Now that some x86-based system use
EFI instead of a traditional BIOS, I guess we can't just assume that
x86 or x86-64 implies there's a BIOS.

-- 
Jean Delvare
