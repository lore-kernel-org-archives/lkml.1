Return-Path: <linux-kernel-owner+w=401wt.eu-S1760552AbXFRIgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760552AbXFRIgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbXFRIgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:36:12 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:52192 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbXFRIgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:36:11 -0400
To: mingo@elte.hu
CC: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, kiran@scalex86.org
In-reply-to: <20070618083109.GA23572@elte.hu> (message from Ingo Molnar on
	Mon, 18 Jun 2007 10:31:09 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu> <20070618083109.GA23572@elte.hu>
Message-Id: <E1I0ChN-0006nd-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 10:34:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > This change causes the memory access of the "easy" spin-loop portion 
> > > to be more agressive: after the REP; NOP we'd not do the 'easy-loop' 
> > > with a simple CMPB, but we'd re-attempt the atomic op.
> > 
> > It looks as if this is going to overflow of the lock counter, no?
> 
> hm, what do you mean? There's no lock counter.

I mean, the repeated calls to decb will pretty soon make lock->slock
wrap around.

Miklos
