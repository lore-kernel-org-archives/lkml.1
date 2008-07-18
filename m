Return-Path: <linux-kernel-owner+w=401wt.eu-S1760092AbYGRMmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbYGRMmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 08:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbYGRMl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 08:41:59 -0400
Received: from senator.holtmann.net ([87.106.208.187]:60691 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYGRMl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 08:41:58 -0400
Subject: Re: The request_firmware() changes causing problems with make-kpkg
From: Marcel Holtmann <marcel@holtmann.org>
To: Theodore Tso <tytso@mit.edu>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
In-Reply-To: <20080718115833.GC11221@mit.edu>
References: <20080718115833.GC11221@mit.edu>
Content-Type: text/plain
Date: Fri, 18 Jul 2008 14:42:16 +0200
Message-Id: <1216384936.22564.53.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

> Using 2.6.26-git4 and -git6, and with CONFIG_FIRMWARE_IN_KERNEL=y,
> make modules_install is calling firmware_install, which is dropping
> files in /lib/firmware --- which make-kpkg is happily picking up and
> including in the debian kernel package.  Which was fine --- until I
> tried to build and install kernel package for -git6, at which point I
> got an error at install time because the second package was tying to
> overwrite files installed by the first linux-image file.  Doh!
> 
> Given that Ubuntu's firmware loader already tries to find firmware at
> /lib/firmware/<kpkg> and only if that fails, to load it from
> /lib/firmware, it seems like the obvious thing to do is to add a
> quickie CONFIG option which changes the default setting of
> INSTALL_FW_PATH in the top-level makefile from /lib/firwmare to
> /lib/firmware/<kver>.
> 
> Maybe the userspace for other distributions won't support this, but
> they can simply not use this CONFIG option for now; but it will solve
> the problem for all Ubuntu, and possibly Debian, users who want to
> build their own kernel using make-kpkg.  If I cons a patch like this,
> is there likely going to be any objections with it getting merged?

sounds like a good idea to me. I am going to prepare a patch for udev to
actually look at /lib/firmware/`uname -r`/ first to unify all the
distros again.

Regards

Marcel


