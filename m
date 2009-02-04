Return-Path: <linux-kernel-owner+w=401wt.eu-S1760239AbZBDV5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbZBDV5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZBDV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:57:12 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754007AbZBDV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:57:11 -0500
Date: Wed, 4 Feb 2009 13:56:46 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Frans Pop <elendil@planet.nl>, rjw@sisk.pl, jbarnes@virtuousgeek.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in
 pci_legacy_suspend
In-Reply-To: <1233783502.4612.7.camel@pasglop>
Message-ID: <alpine.LFD.2.00.0902041355320.3247@localhost.localdomain>
References: <200902040154.36018.rjw@sisk.pl>  <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl>  <1233712613.16867.136.camel@pasglop> <200902041115.00842.elendil@planet.nl> <1233783502.4612.7.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Feb 2009, Benjamin Herrenschmidt wrote:
> 
> How so ? I've had such backtraces with no other info in my log...

_with_ that patch?

It very much replaces a warning with no further info with

+                       WARN_ONCE(pci_dev->current_state != prev,
+                               "PCI PM: Device state not saved by %pF\n",
+                               drv->suspend);

And notice the "%pF" and the 'drv->suspend': it should tell you exactly 
which suspend routine it was that messed up.

		Linus
