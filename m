Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbZDES5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbZDES5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 14:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZDES5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 14:57:32 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:50426 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbZDES5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 14:57:31 -0400
Date: Sun, 5 Apr 2009 20:57:27 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Frans Meulenbroeks <fransmeulenbroeks@gmail.com>
Cc: linux-kernel@vger.kernel.org, beagleboard@googlegroups.com,
       openembedded-devel@openembedded.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] drivers/mmc/core/core.c: extend limit
Message-ID: <20090405205727.7a86d61b@mjolnir.ossman.eu>
In-Reply-To: <alpine.LNX.2.00.0903252248430.32070@linux-suse.site>
References: <alpine.LNX.2.00.0903252248430.32070@linux-suse.site>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Mar 2009 23:03:28 +0100 (CET)
Frans Meulenbroeks <fransmeulenbroeks@gmail.com> wrote:

> 
> This did not help me as the limit was already at 300000. However, I 
> decided to raise the limit to 500000. Still no go so I also doubled the 
> read limit from 100000 to 200000. After that the cards work without 
> problem. Changing the write timing back to 300000 brought the problem back 
> so apparently both timings need to be extended. Attached is the patch I 
> used for this. As it is a timeout limit value, it should not harm anyone, 
> and a longer timeout at least allows more cards to be used.
> 

Unfortunately some controllers cannot cope with huge timeouts and will
complain. And such a huge timeout shouldn't be needed (and they weren't
any larger in .27).

> 
> What somewhat troubles me is that this worked in .27, so it might be this 
> patch does not address the root cause. Then again this is the best I can 
> do. If someone has a better solution, I am more than happy to test it.
> 

Indeed. Have you enabled MMC_DEBUG and checked that the controller
actually follows the configured timeouts?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
