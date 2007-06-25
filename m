Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXFYWxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXFYWxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 18:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbXFYWxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 18:53:38 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:34464 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbXFYWxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 18:53:37 -0400
Message-ID: <46804697.2080603@gmail.com>
Date: Tue, 26 Jun 2007 00:49:59 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: =?UTF-8?B?VG9tYXN6IEvFgm9jemtv?= <kloczek@rudy.mif.pg.gda.pl>
CC: Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl> <20070624200837.16e11305@the-village.bc.nu> <Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl> <20070624215724.025a5de5@the-village.bc.nu> <Pine.BSO.4.63.0706251052380.25800@rudy.mif.pg.gda.pl> <s5h3b0gi9mp.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251308020.25800@rudy.mif.pg.gda.pl> <s5hzm2ogqr7.wl%tiwai@suse.de> <Pine.BSO.4.63.0706251840080.25800@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0706251840080.25800@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2007 07:00 PM, Tomasz Kłoczko wrote:

> $ strace -f -e trace=file galeon 2>&1 | grep dev/snd
> [pid 28593] open("/dev/snd/controlC0", O_RDWR) = 46
> [pid 28593] open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK) = 47

[ ... ]

> [pid 30173] open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_ASYNC) = -1 
> EBUSY (Device or resource busy)
> [..]
> 
> /dev/snd/pcmC0D0p is busy ? YES because it was oppened by another 
> application in non blocking mode which makes device .. unavalable to 
> other :)

Nothing to do with O_NONBLOCK:

$ strace -f -e trace=file firefox 2>&1 | grep dev/snd
[pid  1889] ....
[pid  1889] open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK) = 38
[pid  1889] open("/dev/snd/controlC0", O_RDONLY) = 37
[pid  1889] open("/dev/snd/timer", O_RDONLY|O_NONBLOCK) = 37

$ strace -f -e trace=file ogg123 foo.ogg 2>&1 | grep dev/snd
[pid  1916] ...
[pid  1916] open("/dev/snd/pcmC0D0p", O_RDWR|O_NONBLOCK|O_APPEND) = 5
[pid  1916] open("/dev/snd/controlC0", O_RDONLY) = 4
[pid  1916] open("/dev/snd/timer", O_RDONLY|O_NONBLOCK) = 4

And both the youtube video (flash 9) and my ogg file play fine. Now, I don't 
actually know about that O_ASYNC thing you have in there but it looks as 
though you're simply not using dmix. Which card, and if you specify an ALSA 
device somewhere, is it the "default" device?

And fix your inbound mailer -- it's rejecting my posts.

Rene.

