Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYE0CPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYE0CPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 22:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYE0CPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 22:15:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33081 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYE0CPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 22:15:21 -0400
Date: Mon, 26 May 2008 20:15:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michal Schmidt <mschmidt@redhat.com>, Daniel Walker <dwalker@mvista.com>,
       linville@tuxdriver.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, arjan@infradead.org
Subject: Re: [PATCH] net: wireless: airo semaphore to mutex
Message-ID: <20080527021503.GH30894@parisc-linux.org>
References: <20080522232103.120033152@mvista.com> <20080526192914.31045d09@brian.englab.brq.redhat.com> <200805271117.23051.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805271117.23051.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2008 at 11:17:22AM +1000, Rusty Russell wrote:
> On Tuesday 27 May 2008 03:29:14 Michal Schmidt wrote:
> > Mutexes are not allowed in interrupt context, not even mutex_trylock.
> 
> As an aside, does anyone know why?  I know the documentation says so, but it 
> wasn't immediately obvious to me.  I asked before to no response...

Because mutexes have an owner.  In interrupt context, there is no owner.
This owner is used to do priority boosts as well as debugging.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
