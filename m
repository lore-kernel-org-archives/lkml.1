Return-Path: <linux-kernel-owner+w=401wt.eu-S1763478AbYFEX3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763478AbYFEX3n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 19:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYFEX33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 19:29:29 -0400
Received: from linode.ducksong.com ([64.22.125.164]:56784 "EHLO
	linode.ducksong.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYFEX32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 19:29:28 -0400
Subject: Re: [fixed] [patch] Re: [bug] stuck localhost TCP connections,
	v2.6.26-rc3+
From: Patrick McManus <mcmanus@ducksong.com>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       peterz@infradead.org, LKML <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, rjw@sisk.pl,
       Andrew Morton <akpm@linux-foundation.org>, johnpol@2ka.mipt.ru
In-Reply-To: <Pine.LNX.4.64.0806052355420.2522@wrl-59.cs.helsinki.fi>
References: <20080603094057.GA29480@elte.hu>
	 <Pine.LNX.4.64.0806032245490.3474@wrl-59.cs.helsinki.fi>
	 <Pine.LNX.4.64.0806040052270.3474@wrl-59.cs.helsinki.fi>
	 <20080603.150344.145518113.davem@davemloft.net>
	 <Pine.LNX.4.64.0806040208350.7315@wrl-59.cs.helsinki.fi>
	 <20080605142244.GA19216@elte.hu>
	 <Pine.LNX.4.64.0806052059380.31672@wrl-59.cs.helsinki.fi>
	 <Pine.LNX.4.64.0806052355420.2522@wrl-59.cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Date: Thu, 05 Jun 2008 19:29:31 -0400
Message-Id: <1212708571.19522.10.camel@tng>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-06 at 00:13 +0300, Ilpo Järvinen wrote:

> 
> I'm out of new ideas what could be still wrong (I got confused and
> lost 
> track number of times while I tried to verify socket locking today and 
> probably don't have more time for that now)... Unless somebody else 
> (Patrick?) comes up with something quickly,

Sorry, I don't see anything - it seems to boil down to the same code in
the DA and non-DA case as far as I can tell, but after a while all the
twisty passages seem to look alike.

If Ingo confirms that the recv end was running the locking patch code,
it would be interesting to just confirm the sysreq+t looks the same as
before - it is possible the patch turned the race into a non-obvious
deadlock.

I'm sure your smaller revert will make the problem go away just as the
larger one did, fwiw. 

The other odd thing is that Ingo did a lot of experimentation and was
only making this happen on localhost before (though I agree there is
nothing inherent about that lock and localhost) - isn't it odd that the
first trigger of it now is between two hosts? What do you make of that?




