Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbZGTXuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbZGTXuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 19:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZGTXuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 19:50:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50536 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753965AbZGTXuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 19:50:22 -0400
Date: Tue, 21 Jul 2009 00:51:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
Subject: Re: inotify on /dev/vcsa?
Message-ID: <20090721005108.574d5145@lxorguk.ukuu.org.uk>
In-Reply-To: <20090720234618.GR5397@const.famille.thibault.fr>
References: <20090720234618.GR5397@const.famille.thibault.fr>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> An ioctl could be devised to wait for updates, but I was wondering
> if there could be a way to just use inotify for that.  However,
> drivers/char/vc_screen.c would have to collect the list of opened files
> in order to notify all of them (processes may even have opened another
> node with same devno as /dev/vcsa), which is not really pretty, and
> actually maybe some other device drivers would want to achieve the same
> kind of thing, so I was wondering whether that could fit into another
> place like the generic device infrastructure?

I would have thought poll() would have been cleaner. Or perhaps extending
the VT event interface I added to the vt drivers in the current patches
pending for 2.6.32 - poll support would probably be a bit lighter as
you'd just need to do something like

	event_count++;
	wake_up(&vcsa_event_wait);

and check for a count change
