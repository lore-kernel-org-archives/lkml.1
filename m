Return-Path: <linux-kernel-owner+w=401wt.eu-S932438AbZJFTSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932438AbZJFTSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbZJFTSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:18:37 -0400
Received: from lixom.net ([66.141.50.11]:51268 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758443AbZJFTSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:18:37 -0400
Date: Tue, 6 Oct 2009 14:35:47 -0500
From: Olof Johansson <olof@lixom.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: Can't do mrproper without knowing the previous ARCH
Message-ID: <20091006193547.GA31106@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

The saving away of arch/cross info is neat, but some of the side effects
are a bit confusing.

See below, this is from a current git pull as of today:

$ make ARCH=foo foo_defconfig
Makefile:483: /work/olof/linux-2.6/arch/foo/Makefile: No such file or directory
make: *** No rule to make target `/work/olof/linux-2.6/arch/foo/Makefile'.  Stop.
$ export ARCH=powerpc
$ make foo_defconfig
Makefile:210: *** ARCH changed from "foo" to "powerpc". Use "make mrproper" to fix it up.  Stop.
$ make mrproper
Makefile:210: *** ARCH changed from "foo" to "powerpc". Use "make mrproper" to fix it up.  Stop.
$ make ARCH= mrproper
Makefile:571: /work/olof/linux-2.6/arch//Makefile: No such file or directory
make: *** No rule to make target `/work/olof/linux-2.6/arch//Makefile'.  Stop.
$ make mrproper
Makefile:210: *** ARCH changed from "foo" to "powerpc". Use "make mrproper" to fix it up.  Stop.
$ export ARCH=
$ make mrproper
Makefile:571: /work/olof/linux-2.6/arch/foo/Makefile: No such file or directory
make: *** No rule to make target `/work/olof/linux-2.6/arch/foo/Makefile'.  Stop.
$


It would be nice if I could do a make mrproper without knowing the
previous arch that the tree was configured for.

Also, like above, if I set an invalid ARCH I can't seem to get out of
this loop since I can't run mrproper at all. :-)


-Olof
