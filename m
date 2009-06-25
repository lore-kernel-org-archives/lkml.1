Return-Path: <linux-kernel-owner+w=401wt.eu-S1753725AbZFYRIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbZFYRIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZFYRIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:08:14 -0400
Received: from mail2.cray.com ([136.162.64.100]:39694 "EHLO mail2.cray.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbZFYRIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:08:14 -0400
X-Greylist: delayed 1734 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2009 13:08:14 EDT
Date: Thu, 25 Jun 2009 09:39:17 -0700
From: Kyle Hubert <khubert@cray.com>
To: linux-kernel@vger.kernel.org
Cc: Igor Gorodetsky <igorodet@cray.com>
Subject: 2.6 Makefile replacement for VPATH
Message-ID: <20090625163916.GN6248@cray.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Cray-VirusStatus: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi. I'm requesting information about how to handle a VPATH situation
for drivers in the 2.6 build, with the corresponding solution that we
have.

I refer to VPATH with regards to the situation where you can have
multiple Makefiles target the same source file to build different
objects. In particular, we are using the same source file recompiled
with different options to be able to support different devices.

This is where VPATH can help in the GNU Makefile tradition. Yet, the
2.6 build system has multiple stages to build driver modules, and as
such the VPATH variable is not carried forward. How do other people
handle this?

If you use an obj-m that refers via relative directories to the source
file, ie: "../src", then the two resulting object files have the same
name and the last compiled one will be listed in
.tmp_versions/drv.mod. This will be the only one linked into an
drv.ko.

If you use a multi-object, ie: drv-objs, then you can split the two
drivers into two different names. Each multi-object's parts are
compiled and linked into the multi-object's .o during the compilation
stage, and two .mod files will be created. Thus, two .kos will be
linked during the final stage. This appears to be a solution. However,
during the compilation stage, the two multi-objects will recompile the
original "../src/src.o" intermediary object. This affects the date of
the intermediary .o, and each subsequent execution of the Make command
will consider it a candidate for recompile, and the two drivers will
be rebuilt, regardless of any source code changes.

How do others handle this? Do they just move their driver outside of
the kernel Makefiles so they can iterate through the two builds via
traditional Make routines?

Thank you,
-Kyle Hubert
