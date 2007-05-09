Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbXEIJMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbXEIJMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbXEIJMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:12:18 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:32901 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXEIJMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:12:17 -0400
Message-ID: <46419036.8090504@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 11:11:18 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
References: <4640E17E.7090909@drzeus.cx> <46416255.3060105@drzeus.cx> <4641643D.4040305@yahoo.com.au> <464169C8.9060002@drzeus.cx> <46416B9A.3020008@yahoo.com.au> <46417D97.9090108@drzeus.cx>
In-Reply-To: <46417D97.9090108@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> The host->removed member is only used for this simple test. It is set in
> mmc_host_remove() to indicate that the removal process has begun. At
> this point it is invalid to call mmc_detect_change() (the place this
> patch fixes). So the spinlocks are mostly there so that things are
> properly ordered when we go SMP. Some creative barriers would probably
> work as well, but I find spinlocks more "normal" and hence more readable.

Sounds to me like either struct xyz_host { atomic_t removed; } would do
the job, or that actually wider regions of mmc_host_remove() and
mmc_detect_change() need to be serialized.
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
