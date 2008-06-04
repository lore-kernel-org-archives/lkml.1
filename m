Return-Path: <linux-kernel-owner+w=401wt.eu-S1759727AbYFDU4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759727AbYFDU4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYFDU4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:56:38 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45546 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbYFDU4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:56:38 -0400
Date: Wed, 4 Jun 2008 23:56:34 +0300 (EEST)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wrl-59.cs.helsinki.fi
To: David Miller <davem@davemloft.net>
cc: mingo@elte.hu, peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, rjw@sisk.pl,
       Andrew Morton <akpm@linux-foundation.org>, johnpol@2ka.mipt.ru,
       mcmanus@ducksong.com
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
 v2.6.26-rc3+
In-Reply-To: <20080604.112426.62778239.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806042202030.6328@wrl-59.cs.helsinki.fi>
References: <20080603094057.GA29480@elte.hu> <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
 <20080604072311.GA32491@elte.hu> <20080604.112426.62778239.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; boundary="-696208474-246666717-1212606363=:6328"
Content-ID: <Pine.LNX.4.64.0806042336130.8012@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696208474-246666717-1212606363=:6328
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0806042336131.8012@wrl-59.cs.helsinki.fi>

On Wed, 4 Jun 2008, David Miller wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 4 Jun 2008 09:23:11 +0200
> 
> > * Ilpo Järvinen <ilpo.jarvinen@helsinki.fi> wrote:
> >
> > > ...I couldn't immediately find anything obviously wrong with those 
> > > changes but the patch below might be worth of a try (without the 
> > > revert of course). If it ever spits out that WARN_ON for you, we were 
> > > playing with fire too much and it's better to return on the safe side 
> > > there...
> > 
> > i'll queue it up for testing, but no promises about speedy action here - 
> > the test cycle is really long with this bug.
> 
> Ilpo posted another patch which fixes a locking bug in the
> code, please test with that patch.  I include it below so
> that you know exactly which one I am referring to.

Do you know if TCP ever needs to lock the child sk again (after creating 
it and it has started to live on its own) from a context that has already 
locked the listen_sk (it could deadlock after this change)?


-- 
 i.
---696208474-246666717-1212606363=:6328--
