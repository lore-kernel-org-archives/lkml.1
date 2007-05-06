Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbXEFMeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbXEFMeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 08:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXEFMeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 08:34:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41770 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752216AbXEFMeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 08:34:15 -0400
Date: Sun, 6 May 2007 13:37:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Colin Leroy <colin@colino.net>
Cc: Richard Purdie <rpurdie@openedhand.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] led-class.c permission change
Message-ID: <20070506133759.650a6453@the-village.bc.nu>
In-Reply-To: <20070506002028.53230d56@localhost.localdomain>
References: <20070505124954.0e2bcf53@localhost.localdomain>
	<20070505224803.67f76749@the-village.bc.nu>
	<20070506002028.53230d56@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Take a look at the various pam console management modules (and also
> > beat people up to get revoke() support into the kernel).
> 
> So, you suggest me to link my plugin to libpam and find something that
> allows the plugin to write into /brightness? 

Much simpler than that. Most distributions have a pam module already
which updates permissions on things that the "console" user may want to
access directly (eg /dev/audio* /dev/cdrom etc) but which should
otherwise be protected from misuse (eg people with cronjobs that run
eject - an old an very funny SunOS prank)

If your distribution is like most and uses pam_console then see man 5
console.perms and add a rule to the /etc/security/console.perms file for
your file. At that point it will happily change the rights back and
forth for you as required.
