Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZHJM2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZHJM2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbZHJM2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:28:16 -0400
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:48209 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZHJM2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:28:15 -0400
Date: Mon, 10 Aug 2009 14:28:13 +0200
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org
Subject: Re: rfkill rework in 2.6.31-rc, hal/dbus access changes?
Message-ID: <20090810122813.GM844@gamma.logic.tuwien.ac.at>
References: <20090711091427.GB14367@gamma.logic.tuwien.ac.at> <1247338473.9709.107.camel@localhost.localdomain> <20090711195911.GA31549@gamma.logic.tuwien.ac.at> <1247346745.9709.129.camel@localhost.localdomain> <20090810104302.GD844@gamma.logic.tuwien.ac.at> <1249906970.12361.11.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249906970.12361.11.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

thanks a lot for your remarks, and sorry, in fact I am a complete
ignorant wrt all these things, just programming what I need ;-)
Some questions:

On Mo, 10 Aug 2009, Johannes Berg wrote:
> Umm. That's wrong in multiple ways. You don't need threads, and you
> don't need to poll. Just open /dev/rfkill, add the fd to the event loop
> and read events.

Aehm, I am doing exactely what the user space 
	rfkill event
is doing. Isn't that supposed to be?

And threads I need (AFAIU) because the read from the fd will blcok
until there is an event, and in the mean time the user might
do something with the applet (like disabling manually the rfkill,
or configuration). So one thread is listening to user events (the 
normal pygtk loop) and one is reading from /dev/rfkill and 
in case something comes in it takes the respective actions.

In python-speak I do:

	fd = os.open("/dev/rfkill", os.O_RDONLY)
	p = select.poll()
	p.register(fd, select.POLLIN | select.POLLHUP)
	n = p.poll()
	if (t == select.POLLIN)
	  buf = os.read(fd, 8)
	....

Isn't that supposed to work like that?

At least that is what rfkill.c does in the event loop.

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
TODBER (n.)
One whose idea of a good time is to stand behind his front hedge and
give surly nods to people he doesn't know.
			--- Douglas Adams, The Meaning of Liff
