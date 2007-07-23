Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXGWAE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXGWAE7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763000AbXGWAEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:04:51 -0400
Received: from ozlabs.org ([203.10.76.45]:43128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761148AbXGWAEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:04:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18083.61595.217126.824924@cargo.ozlabs.ibm.com>
Date: Mon, 23 Jul 2007 10:04:43 +1000
From: Paul Mackerras <paulus@samba.org>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, david@lang.hm,
       Miklos Szeredi <miklos@szeredi.hu>, nigel@suspend2.net,
       linux-kernel@vger.kernel.org, miltonm@bga.com, ying.huang@intel.com,
       linux-pm@lists.linux-foundation.org,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707230842.22121.nigel@nigel.suspend2.net>
References: <Pine.LNX.4.44L0.0707221116060.15224-100000@netrider.rowland.org>
	<200707230842.22121.nigel@nigel.suspend2.net>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham writes:

> I guess I want to persist because all of these issues aren't utterly
> unsolvable. It's just that we don't have the infrastructure yet to
> figure out the solutions to these issues trivially. Take, for example,

Ever heard of the halting problem? :)  It's not just a matter of
infrastructure.  You very quickly get into questions that are
mathematically undecideable.

> the locking issue. If we could call some function to say "What process
> holds this lock?", then task A could know that it's waiting on task B
> and put that information somewhere. We could then use the information
> to freeze task B before task A.

But how would that help?  If task B holds the lock, then we can't
freeze it until it's released the lock.  Then the question is, what
does task B need in order to get to the point where it releases the
lock?  And so on.  It rapidly gets not just extremely messy, but
actually impossible to compute in general.

Paul.
