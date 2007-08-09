Return-Path: <linux-kernel-owner+w=401wt.eu-S939302AbXHINFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939302AbXHINFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 09:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932443AbXHINFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 09:05:36 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:3698 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765571AbXHINFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 09:05:35 -0400
Date: Thu, 9 Aug 2007 14:04:49 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: linux-kernel@vger.kernel.org, drfickle@us.ibm.com, mel@csn.ul.ie,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc2-mm1 -- PPC G5 kernel compile failure
Message-ID: <20070809130449.GB3091@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809015106.cd0bfc53.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SPF-Guess: neutral
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seeing the following compile error on a G5 mac:

  drivers/video/tdfxfb.c: In function 'tdfxfb_setup':
  drivers/video/tdfxfb.c:1341: error: 'opt' undeclared (first use in this
                                                                 function)
  drivers/video/tdfxfb.c:1341: error: (Each undeclared identifier is
                                                        reported only once
  drivers/video/tdfxfb.c:1341: error: for each function it appears in.)

This seems to be the following fragment from tdfxfb-hardware-cursor:

+               } else if (!strcmp(this_opt, "hwcursor")) {
+                       hwcursor = simple_strtoul(opt + 9, NULL, 0);

I guess the nieve fix would be s/opt/this_opt, but I am also
suspicious of the +9 here as hwcursor is only 8 long?  Now this
seems to take a numeric value and I assume that is via hwcursor=N,
if so then the +9 would make sense _if_ the strcmp was against
"hwcursor=".

Krzysztof?

-apw
