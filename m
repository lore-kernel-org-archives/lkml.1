Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbXLVINL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbXLVINL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 03:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXLVIM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 03:12:57 -0500
Received: from outbound-mail-40.bluehost.com ([69.89.20.194]:34927 "HELO
	outbound-mail-40.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751059AbXLVIM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 03:12:56 -0500
From: "Richard D" <richard@embunus.com>
To: "'Pavel Machek'" <pavel@ucw.cz>,
       "'Matthew Bloch'" <matthew@bytemark.co.uk>
Cc: <linux-kernel@vger.kernel.org>
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz>
In-Reply-To: <20071221125812.GA4052@ucw.cz>
Subject: RE: Testing RAM from userspace / question about memmap= arguments
Date: Sat, 22 Dec 2007 13:42:47 +0530
Message-ID: <000001c84472$74b245e0$5e16d1a0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AchD0XMyyCvsAu6QRgCpY1nxpTPfUQAoMWZg
Content-Language: en-us
X-Identified-User: {2260:host187.hostmonster.com:embunusc:embunus.com} {sentby:bopbeforesmtp 121.247.188.187 authed with embunus.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cant you, modify bootmem allocator to test with memtest patterns and then
use kexec (as Pavel suggested) to test the one where kernel was sitting
earlier?

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org
[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Pavel Machek
Sent: Friday, December 21, 2007 6:28 PM
To: Matthew Bloch
Cc: linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments

On Tue 2007-12-18 17:06:24, Matthew Bloch wrote:
> Hi - I'm trying to come up with a way of thoroughly testing every byte
> of RAM from within Linux on amd64 (so that it can be automated better
> than using memtest86+), and came up with an idea which I'm not sure is
> supported or practical.
> 
> The obvious problem with testing memory from user space is that you
> can't mlock all of it, so the best you can do is about three quarters,
> and hope that the rest of the memory is okay.
> 
> In order to test all of the memory, I'd like to run the user-space
> memtester over two boots of the kernel.
> 
> Say we have a 1024MB machine, the first boot I'd not specify any
> arguments and assume the kernel would start at the bottom of physical
> memory and work its way up, so that the kernel & working userspace would
> live at the bottom, and the rest would be testable from space.
> 
> On the second boot, could I then specify:
> 
> memmap=exact memmap=512M@512M memmap=512M@0

Actually, with kexec, you can probably doing without reboot.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

