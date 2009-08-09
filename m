Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZHIPAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZHIPAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 11:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZHIPAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 11:00:30 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45472 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751617AbZHIPAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 11:00:30 -0400
Date: Sun, 9 Aug 2009 11:00:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
In-Reply-To: <4A7ED700.9080407@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0908091058001.10326-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Aug 2009, [UTF-8] Ozan Çağlayan wrote:

> Bruno Prémont wrote:
> > I tried bisecting this but bisect did end up on a fully unrelated commit
> > (which is not even being compiled into my kernel).
> > Possibly the failed bisect could be related to mis-classified kernel
> > panic/hang while pulling the USB cable (there were two such panics for the
> > whole iteration)?
> >
> > There are quite a few patches touching tty, ttyUSB and friends between
> > rc4 and now so pretty hard to guess on the correct one.
> >
> > The oops always happens when I disconnect the USB serial console (here
> > the one built into Marvell SheevaPlug) while having minicom connected
> > to it.
> > During the bisection for the last few bad iterations minicom got killed
> > (segfault), the bad ones on the iteration left a minicom zombie in 'D'
> > state.
> >
> > Regards,
> > Bruno
> >
> >   
> 
> That may be a related/possible fix for that,
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b68f2fb9e73f46037fbeca5fbd4ae8a7ddd8ef6b

That patch is already present in 2.6.31-rc5.

The problem here may be related to the fact that the serial port is
being used as a console.  For non-console ports this doesn't happen.

Alan Stern

