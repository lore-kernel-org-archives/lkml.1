Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbXLaNY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbXLaNY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 08:24:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbXLaNYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 08:24:46 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:35387 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbXLaNYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 08:24:45 -0500
Date: Mon, 31 Dec 2007 14:23:01 +0100
Message-Id: <78342039@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: 7eggert@gmx.de, David Miller <davem@davemloft.net>
Cc: bunk@kernel.org, jengelh@computergmbh.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+MocIkTOWZGCqu2beBsPXMw93bEazpCqD/3cMP6coTGSIq0
 PwBtEHu1Y30M1N2CADMnwX0Wr9ms6jiQOl26udji6qdidUThgg=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when i had that module modular and added to the initrd, udev didn`t work, though.
same error message:

udevd[1226]: init_udev_socket: error getting socket: Address family not supported by protocol 

not sure if i did a mistake here....

anyway, this message is not obvious to the end user.

i like the kernel being modular, but i also like it if things "just work" - and with "allmodconfig", modular UNIX domain sockets seem to create hassle.
(see http://forums.gentoo.org/viewtopic-t-476363-highlight-.html or http://forums.gentoo.org/viewtopic-t-463793-highlight-.html )


so, if this patch is being rejected, maybe it would be useful if udev would give a proper hint, if it`s missing this kernel feature. 

btw, udev documentation telling this:

  - The kernel must have sysfs, unix domain sockets and networking enabled.
    (unix domain sockets (CONFIG_UNIX) as a loadable kernel module may work,
    but it is completely silly - don't complain if anything goes wrong.)

furthermore, if this needs to be modular, then i`d please have tcp/ip networking modular, too. :)

regards
roland

ps:
not being a skilled programmer, so this is mostly an admins/users perspective.


> 
> From: Bodo Eggert <7eggert@gmx.de>
> Date: Mon, 31 Dec 2007 13:09:43 +0100 (CET)
> 
> > As suggested by Adrian Bunk, UNIX domain sockets should always be built in 
> > on normal systems. This is especially true since udev needs these sockets
> > and fails to run if UNIX=m.
> > 
> > Signed-Off-By: Bodo Eggert <7eggert@gmx.de>
> 
> People who use udev can make sure they have it built into their kernel
> if they have such a dependency.
> 
> Not everyone uses udev, and therefore needs AF_UNIX non-modular.
> 
> I keep seeing this crap patch get submitted and I'm going to keep
> dropping it because it's bogus.
> 
> It seems to stem from some filesystem interface or whatever that the
> VFS folks don't want to export or one they want to now stop exporting.
> 
> But that is a really cruddy reason to want to force AF_UNIX to not
> be allowed to be modular, and the udev thing just makes it more of a
> joke rather than a good technical reason.
> 


_______________________________________________________________________
Jetzt neu! Schützen Sie Ihren PC mit McAfee und WEB.DE. 30 Tage
kostenlos testen. http://www.pc-sicherheit.web.de/startseite/?mc=022220

