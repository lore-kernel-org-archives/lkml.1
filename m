Return-Path: <linux-kernel-owner+w=401wt.eu-S932198AbYD1Gmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932198AbYD1Gmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 02:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338AbYD1GmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 02:42:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52191
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753918AbYD1GmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 02:42:21 -0400
Date: Sun, 27 Apr 2008 23:42:21 -0700 (PDT)
Message-Id: <20080427.234221.40346351.davem@davemloft.net>
To: bunk@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kconfig 'depend' vs. 'select'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080428063953.GA2088@cs181133002.pp.htv.fi>
References: <20080427.174536.62560212.davem@davemloft.net>
	<20080428063953.GA2088@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 28 Apr 2008 09:39:54 +0300

> On Sun, Apr 27, 2008 at 05:45:36PM -0700, David Miller wrote:
> > 
> > I'm trying to stir up interest in solving a problem that seems to pop
> > up frequently. :)
> > 
> > The short story is:
> > 
> > 1) If you say your driver "depend"s on a subsystem providing a set of
> >    interfaces you need, this doesn't work properly if your driver is
> >    marked built-in and that subsystem you need is modular for some
> >    reason.
> >...
> 
> This should work.

It doesn't.

> Can you give an example of the problem you are thinking of?

We've hit this specifically with the intel iwlwifi wireless drivers
over the past week.

> What about "select"?
> 
> That's exactly what it's doing.

Select doesn't enable downstream dependencies, it just blindly turns
it on, non-modular.  That's not what we want at all.

