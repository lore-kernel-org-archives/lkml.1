Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYLCMpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYLCMpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYLCMpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:45:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:57899 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYLCMpA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:45:00 -0500
Subject: Re: [Patch V3 0/3] Enable irqs when waiting for rwlocks
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, tee@sgi.com,
       mingo@elte.hu, linux-arch@vger.kernel.org
In-Reply-To: <1228307798.1009.1.camel@nathan.suse.cz>
References: <20081104122405.046233722@attica.americas.sgi.com>
	 <20081202161311.ae3376cb.akpm@linux-foundation.org>
	 <20081203113744.GE8970@sgi.com>  <1228307117.9673.232.camel@twins>
	 <1228307798.1009.1.camel@nathan.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 03 Dec 2008 13:44:49 +0100
Message-Id: <1228308289.9673.237.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-03 at 13:36 +0100, Petr Tesarik wrote:
> Peter Zijlstra píše v St 03. 12. 2008 v 13:25 +0100:
> > On Wed, 2008-12-03 at 05:37 -0600, Robin Holt wrote:
> > > > It's a bit regrettable to have different architectures behaving in
> > > > different ways.  It would be interesting to toss an x86_64
> > > > implementation into the grinder, see if it causes any problems, see if
> > > > it produces any tangible benefits.  Then other architectures might
> > > > follow.  Or not, depending on the results ;)
> > > 
> > > I personally expect SGI to work on this for x86_64 in the future.
> > > Once we actually start testing systems with 128 and above cpus, I
> > > would expect to see these performance issues needing to be addressed.
> > > Until then, it is just a theoretical.
> > 
> > Personally I consider this a ugly hack and would love to see people
> > solve the actual problem and move away from rwlock_t, its utter rubbish.
> 
> Me too, but we don't have that clean and nice solution today, but what
> we _do_ have today are the machines which break badly when interrupts
> are disabled for the whole duration of taking a rwlock_t. :(

Right, which creates an incentive to work on it. So we then either to a
quick and ugly hack and relieve the stress and never again get around to
looking at that particular issue (because management or something
doesn't see the problem anymore) or we do the right thing and fix it
properly.

I prefer the second, but I understand its not always an option.

> Feel free to rewrite all users of rwlock_t. I'll appreciate it, oh so
> very much.

Hehe, I wish! its on my todo list though, along with some other things,
but very unlikely I'll ever get around to it.

The good news is that Eric Dumazet recently got rid of a few prominent
users in the net code.

