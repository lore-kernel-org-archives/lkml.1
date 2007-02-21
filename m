Return-Path: <linux-kernel-owner+w=401wt.eu-S1423096AbXBUU23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423096AbXBUU23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423097AbXBUU22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:28:28 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:42246 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423096AbXBUU22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:28:28 -0500
Date: Wed, 21 Feb 2007 15:28:19 -0500
To: Mockern <Mockern@yandex.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cat problem in tiny_tty driver (the source included)
Message-ID: <20070221202819.GI22464@csclub.uwaterloo.ca>
References: <45DC5F34.000008.04893@tide.yandex.ru> <20070221151554.GA22466@csclub.uwaterloo.ca> <45DC9EA0.000007.11000@webmail18.yandex.ru> <20070221200904.GG22464@csclub.uwaterloo.ca> <45DCA9B6.000001.09623@webmail15.yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DCA9B6.000001.09623@webmail15.yandex.ru>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 11:21:10PM +0300, Mockern wrote:
> cat < /dev/my_tty does nothing, just stopped for reading. I tried to send a data,
> but there was no respond, just waiting.

Well certainly using the jsm driver (which is what I use for the pci
card I play with), doing cat to the port send data and cat from the port
receives, as long as both ports are set to the right baud rates and with
sensible stty settings.

Here are the stty settings I was using when cat worked fine:

speed 9600 baud; rows 0; columns 0; line = 0;
intr = ^C; quit = ^\; erase = ^?; kill = ^U; eof = ^D; eol = <undef>;
eol2 = <undef>; start = ^Q; stop = ^S; susp = ^Z; rprnt = ^R;
werase = ^W; lnext = ^V; flush = ^O; min = 1; time = 0;
-parenb -parodd cs8 hupcl -cstopb cread clocal -crtscts
-ignbrk -brkint -ignpar -parmrk -inpck -istrip -inlcr -igncr icrnl -ixon
-ixoff -iuclc -ixany -imaxbel
-opost -olcuc -ocrnl onlcr -onocr -onlret -ofill -ofdel nl0 cr0 tab0 bs0
vt0 ff0
-isig -icanon iexten -echo -echoe echok -echonl -noflsh -xcase -tostop
-echoprt echoctl echoke

You can read yours using 'stty -a -F /dev/serialdevice'.

Maybe you can find something that has to be changed to do raw reads.

Also make sure there are newlines in the stuff you send, otherwise cat
might not show it for a while, if at all since I think it tries to wait
for a newline before showing the line.

--
Len Sorensen
