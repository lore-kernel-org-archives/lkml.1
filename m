Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbXFRI03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbXFRI03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:26:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXFRI0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:26:21 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:55000 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbXFRI0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:26:21 -0400
To: mingo@elte.hu
CC: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-reply-to: <20070618081204.GA11153@elte.hu> (message from Ingo Molnar on
	Mon, 18 Jun 2007 10:12:04 +0200)
Subject: Re: [BUG] long freezes on thinkpad t60
References: <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu>
Message-Id: <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 18 Jun 2007 10:25:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> To test this theory, could you try the patch below, does this fix your 
> hangs too?

Not tried yet, but obviously it does, since it's a superset of the
previous fix.  I could try without the smb_mb(), but see below.

> This change causes the memory access of the "easy" spin-loop portion
> to be more agressive: after the REP; NOP we'd not do the 'easy-loop'
> with a simple CMPB, but we'd re-attempt the atomic op.

It looks as if this is going to overflow of the lock counter, no?

Miklos
