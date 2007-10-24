Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbXJXDG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbXJXDG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbXJXDGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:06:49 -0400
Received: from lixom.net ([66.141.50.11]:46138 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbXJXDGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:06:48 -0400
Date: Tue, 23 Oct 2007 22:14:01 -0500
From: Olof Johansson <olof@lixom.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: Kconfig: conf segfault (with invalid kconfig contents)
Message-ID: <20071024031401.GA13376@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, no patch, just a bugreport. :)

I did a mistake in some Kconfig changes (locally) and got a segfault
from conf:

#0  0x10005fe0 in sym_check_deps ()
#1  0x10005f40 in sym_check_expr_deps ()
#2  0x1000605c in sym_check_deps ()
#3  0x1000f3f4 in conf_parse ()
#4  0x10003824 in main ()


The way to reproduce is simple. I just added the equivalent of this
to arch/powerpc/Kconfig:

---
config TEST1
        bool
        depends on TEST2 && PCI
        select TEST2

config TEST2
        bool
---

Neither TEST1 nor TEST2 exists in the existing .config when I run make
oldconfig to reproduce.

It's clearly invalid in that it depends on what it selects, but it should
just abort instead.


-Olof
