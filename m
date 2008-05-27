Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbYE0Eez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbYE0Eez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 00:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYE0Eep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 00:34:45 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:23291 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYE0Eeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 00:34:44 -0400
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
From: Daniel Walker <dwalker@mvista.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Michal Schmidt <mschmidt@redhat.com>, linville@tuxdriver.com,
       mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
In-Reply-To: <20080527021503.GH30894@parisc-linux.org>
References: <20080522232103.120033152@mvista.com>
	 <20080526192914.31045d09@brian.englab.brq.redhat.com>
	 <200805271117.23051.rusty@rustcorp.com.au>
	 <20080527021503.GH30894@parisc-linux.org>
Content-Type: text/plain
Date: Mon, 26 May 2008 21:34:41 -0700
Message-Id: <1211862881.18130.243.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-05-26 at 20:15 -0600, Matthew Wilcox wrote:
> On Tue, May 27, 2008 at 11:17:22AM +1000, Rusty Russell wrote:
> > On Tuesday 27 May 2008 03:29:14 Michal Schmidt wrote:
> > > Mutexes are not allowed in interrupt context, not even mutex_trylock.
> > 
> > As an aside, does anyone know why?  I know the documentation says so, but it 
> > wasn't immediately obvious to me.  I asked before to no response...
> 
> Because mutexes have an owner.  In interrupt context, there is no owner.
> This owner is used to do priority boosts as well as debugging.

I don't think regular mutexes do boosting, the rtmutex does tho .. I
think it's more a issue with lockdep complaining about the context, but
that exists to just plain disallow this type of usage on principal .

Daniel

