Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbYHUGiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbYHUGiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbYHUGiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:38:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:37365 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYHUGiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:38:13 -0400
Date: Thu, 21 Aug 2008 08:40:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Move sysctl check into debugging section and don't make it default y
Message-ID: <20080821064009.GB18831@one.firstfloor.org>
References: <1218865985-23403-1-git-send-email-andi@firstfloor.org> <m1myj63neb.fsf@frodo.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1myj63neb.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is a feature change like this doing coming in after the
> merge window?

I considered it a "anti bloat bugfix". Adding 30k of 
object code to allno was a bit too much. 

> Why doesn't an allnoconfig disable sysctl all together?

Because it depends on EMBEDDED and EMBEDDED is not y. Yes it's not
intuitive, on the other hand the end result is reasonable.

> These are the only checks we have against someone doing something
> nasty in the sysctl hierarchy.   We have proven that we don't
> have the discipline to do the right thing with code in the
> core kernel.  I expect out of tree code will be much worse.

My assumption is that they will be run at least once during
a release cycle by someone and then the messages will appear
and be reported. We do the same thing with a lot of other
debug options (lockdep, slab debug, sleep debug etc.,). There's no 
need for this one to be special.

Also I'm not sure the check is all that useful anyways. We
should just not accept any new binary numbered sysctl, and
that's nearly the case anyways.

-Andi

