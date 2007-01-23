Return-Path: <linux-kernel-owner+w=401wt.eu-S933028AbXAWGCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028AbXAWGCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933033AbXAWGCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:02:48 -0500
Received: from outbound0.mx.meer.net ([209.157.153.23]:2468 "EHLO
	outbound0.sv.meer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933028AbXAWGCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:02:47 -0500
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, rdunlap@xenotime.net
Subject: `make htmldocs` fails
References: <20070111222627.66bb75ab.akpm@osdl.org>
From: Don Mullis <dwm@meer.net>
In-Reply-To: <20070111222627.66bb75ab.akpm@osdl.org> (Andrew Morton's message of "Thu\, 11 Jan 2007 22\:26\:27 -0800")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.92 (gnu/linux)
Date: Mon, 22 Jan 2007 22:02:30 -0800
Message-ID: <m364aycmbt.fsf@meer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bisection shows the bad patch to be:
    gregkh-driver-uio-documentation.patch

The htmldocs build failure can be eliminated by:
    quilt remove Documentation/DocBook/kernel-api.tmpl

The error messages were:

    .../linux-2.6.19 $ make htmldocs
      DOCPROC Documentation/DocBook/kernel-api.xml
    Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:521): No description found for parameter 'owner'
    Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:521): No description found for parameter 'info'
    Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:591): No description found for parameter 'idev'
    Error(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//include/linux/uio_driver.h:33): cannot understand prototype: 'struct uio_info '
    Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//include/linux/uio_driver.h): no structured comments found
    make[1]: *** [Documentation/DocBook/kernel-api.xml] Error 1
    make: *** [htmldocs] Error 2

The failure was observed on an up-to-date Fedora Core 5 host. 
