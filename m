Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYELTn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYELTn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbYELTnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:43:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbYELTno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:43:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: 2.6.25-mm1: kmmcd NULL pointer dereference at klist_del+0xe/0x30
Date: Mon, 12 May 2008 21:43:33 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org
References: <20080509171956.GJ30021@hexapodia.org> <20080509164738.2e0af511.akpm@linux-foundation.org> <20080512191041.397f9ccf@mjolnir.drzeus.cx>
In-Reply-To: <20080512191041.397f9ccf@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805122143.33748.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Pierre Ossman wrote:
> On Fri, 9 May 2008 16:47:38 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 9 May 2008 10:19:56 -0700
> > Andy Isaacson <adi@hexapodia.org> wrote:
> > 
> > > Got this twice with 2.6.25-mm1 on my Thinkpad X40, AData 16GB SDHC card
> > > in mmc0 but no filesystem mounted.  I think the oops happened at
> > > suspend/resume time.  Previous kernel was 2.6.25-rc5-mm1 which didn't
> > > exhibit this problem across multiple suspend-resume cycles.
> > > 
> > > Complete logs and pretty much everything else you could want at
> > > http://web.hexapodia.org/~adi/bobble/bobble_2.6.25-mm1-dirty_20080509100634/
> > > 
> > > [104375.816331] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> > > [104375.816338] IP: [<c02d86ce>] klist_del+0xe/0x30
> > 
> > This could be one of those nasty situations where one driver leaves a mess
> > behind it and then another driver later comes along and trips over that
> > mess.
> > 
> 
> There were some problems with removing devices during suspend (which
> the MMC layer does), but AFAIK those patches were backed out and were
> only supposed to come back in a form that allowed such usage. Rafael
> should have the most correct information on that subject.

Those changes went away for good.  At the moment, we only print a warning
if there's a suspend ordering violation.

The problem described here looks like the one fixed by commits
29591b92e19f409d5ad4c099c2b7b5ea56f50dfa and
08119e8966e993993d0ba92b2fba38c582c8f787,
so Andy, please try the current linux-next or even -rc2.

Thanks,
Rafael
