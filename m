Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbYGRL6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbYGRL6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbYGRL6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:58:40 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:37177 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755409AbYGRL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:58:39 -0400
Date: Fri, 18 Jul 2008 07:58:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: The request_firmware() changes causing problems with make-kpkg
Message-ID: <20080718115833.GC11221@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
	sam@ravnborg.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using 2.6.26-git4 and -git6, and with CONFIG_FIRMWARE_IN_KERNEL=y,
make modules_install is calling firmware_install, which is dropping
files in /lib/firmware --- which make-kpkg is happily picking up and
including in the debian kernel package.  Which was fine --- until I
tried to build and install kernel package for -git6, at which point I
got an error at install time because the second package was tying to
overwrite files installed by the first linux-image file.  Doh!

Given that Ubuntu's firmware loader already tries to find firmware at
/lib/firmware/<kpkg> and only if that fails, to load it from
/lib/firmware, it seems like the obvious thing to do is to add a
quickie CONFIG option which changes the default setting of
INSTALL_FW_PATH in the top-level makefile from /lib/firwmare to
/lib/firmware/<kver>.

Maybe the userspace for other distributions won't support this, but
they can simply not use this CONFIG option for now; but it will solve
the problem for all Ubuntu, and possibly Debian, users who want to
build their own kernel using make-kpkg.  If I cons a patch like this,
is there likely going to be any objections with it getting merged?

Regards,

						- Ted
