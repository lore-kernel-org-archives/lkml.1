Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbYELRLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbYELRLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 13:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYELRLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 13:11:13 -0400
Received: from server.drzeus.cx ([85.8.24.28]:35142 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751797AbYELRLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 13:11:12 -0400
Date: Mon, 12 May 2008 19:10:41 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
       rjw@sisk.pl
Subject: Re: 2.6.25-mm1: kmmcd NULL pointer dereference at
 klist_del+0xe/0x30
Message-ID: <20080512191041.397f9ccf@mjolnir.drzeus.cx>
In-Reply-To: <20080509164738.2e0af511.akpm@linux-foundation.org>
References: <20080509171956.GJ30021@hexapodia.org>
	<20080509164738.2e0af511.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008 16:47:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 9 May 2008 10:19:56 -0700
> Andy Isaacson <adi@hexapodia.org> wrote:
> 
> > Got this twice with 2.6.25-mm1 on my Thinkpad X40, AData 16GB SDHC card
> > in mmc0 but no filesystem mounted.  I think the oops happened at
> > suspend/resume time.  Previous kernel was 2.6.25-rc5-mm1 which didn't
> > exhibit this problem across multiple suspend-resume cycles.
> > 
> > Complete logs and pretty much everything else you could want at
> > http://web.hexapodia.org/~adi/bobble/bobble_2.6.25-mm1-dirty_20080509100634/
> > 
> > [104375.816331] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> > [104375.816338] IP: [<c02d86ce>] klist_del+0xe/0x30
> 
> This could be one of those nasty situations where one driver leaves a mess
> behind it and then another driver later comes along and trips over that
> mess.
> 

There were some problems with removing devices during suspend (which
the MMC layer does), but AFAIK those patches were backed out and were
only supposed to come back in a form that allowed such usage. Rafael
should have the most correct information on that subject.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
