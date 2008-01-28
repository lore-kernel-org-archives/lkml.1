Return-Path: <linux-kernel-owner+w=401wt.eu-S1759489AbYA1KQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759489AbYA1KQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:16:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYA1KQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:16:24 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:12730 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734AbYA1KQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:16:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=h4804h0aBj1PPxoD0cfEbw1mfl3tcIZkQ2i7+AhJPjSSY6jzNNFalPaGpe56ZUYi2Jk7esgr8w4DRJdy3vUOFIzzIcyx1Cp2ZOJ4iKKmdyetDEAEC4ae3fka78hi2biSUVXV/G188ucPxuMX29VRw6+29CajfjOKMsiZADM+Xe0=
Message-ID: <8bd0f97a0801280216x56d52028s2ea247dd969e85e2@mail.gmail.com>
Date: Mon, 28 Jan 2008 05:16:20 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [rfc] exposing MMR's of on-chip peripherals for debugging purposes
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we have guys who maintain xml descriptions of all Blackfin processors.
 these include an exhaustive list of all the peripherals and their
MMRs.  for example, there is an element that binds the address, the
MMR name (as described in the processor's hardware manual), the bit
size of it, and all those fun details.  i feed these xml files through
an xsl to generate a C file that populates /sys/kernel/debug/blackfin/
by using the standard debugfs functions.  so when i'm debugging the
watchdog driver, i can simply go into
/sys/kernel/debug/blackfin/watchdog/ and see the watchdog-specific
MMRs and cat/echo them on the fly.  it's been quite handy and feedback
from customers/developers is that it's nicely filled a small void in
the development process.

the trouble is that this file currently weighs in at ~1.8 megs.  this
is because it contains all the information for all Blackfin processors
we support (which currently, is about ~23 variants).  it's only going
to get bigger as we support more.  Bryan cringes at the thought of
submitting it to LKML :).  so i'm fishing around for alternatives ...
the code was originally developed against 2.6.21, so UIO was not a
possibility.  i'm still not sure if it is ... i'd have to research it
a bit more and play with things.

any pointers ?
-mike
