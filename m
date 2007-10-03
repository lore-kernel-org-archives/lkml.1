Return-Path: <linux-kernel-owner+w=401wt.eu-S1755353AbXJCNaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbXJCNaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 09:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbXJCNaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 09:30:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41916 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736AbXJCNaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 09:30:10 -0400
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
In-Reply-To: <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
References: <200710022144.BFF09817.VFFOOJLSFHtQMO@I-love.SAKURA.ne.jp>
	 <Xine.LNX.4.64.0710020557170.21841@us.intercode.com.au>
	 <200710032024.DJF78662.FHOLtMSFOOFJVQ@I-love.SAKURA.ne.jp>
	 <20071003.204356.05853536.yoshfuji@linux-ipv6.org>
	 <Xine.LNX.4.64.0710030529580.6431@us.intercode.com.au>
	 <200710032204.DFF51552.OFOSOFMVQtHLJF@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 15:24:24 +0200
Message-Id: <1191417864.5599.2.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2007-10-03 at 22:04 +0900, Tetsuo Handa wrote:
> James Morris wrote:
> > I'm pretty sure that the singly linked list idea has been rejected a few 
> > times.  Just use the existing API.
> Too bad...
> 
> Well, is there a way to avoid read_lock when reading list?
> 
> Currently, TOMOYO Linux avoids read_lock, on the assumption that
> (1) First, ptr->next is initialized with NULL.
> (2) Later, ptr->next is assigned non-NULL address.
> (3) Assigning to ptr->next is done atomically.

 (4) wmb after asigning ptr->next
 (5) rmb before reading ptr->next

But please do look at the various rcu list primitives. RCU allows one to
avoid non-exclusive locks in many cases.

non-exclusive locks are evil, they must all die...

