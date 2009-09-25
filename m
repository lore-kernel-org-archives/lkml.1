Return-Path: <linux-kernel-owner+w=401wt.eu-S1752955AbZIYOzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbZIYOzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 10:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZIYOzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 10:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbZIYOza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 10:55:30 -0400
Date: Fri, 25 Sep 2009 11:54:59 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       bluesmoke-devel@lists.sourceforge.net
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925115459.7621174a@pedra.chehab.org>
In-Reply-To: <20090925144720.38ea1c1f@infradead.org>
References: <20090924192727.212ce46f@pedra.chehab.org>
	<20090925094855.GA29551@aftab>
	<20090925091130.14135879@pedra.chehab.org>
	<20090925144720.38ea1c1f@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 25 Sep 2009 14:47:20 +0200
Arjan van de Ven <arjan@infradead.org> escreveu:

> On Fri, 25 Sep 2009 09:11:30 -0300
> Mauro Carvalho Chehab <mchehab@redhat.com> wrote:
> 
> > 5) there are very few calls to kernel routines here:
> > list_for_each_entry(), spin_lock_irqsave(), in_unlock_irqrestore(),
> > memcpy(). I don't think any of them will have any problems on working
> > even inside NMI context.
> 
> spinlocks in NMI context don't do what you think they do....
> _irqsave does not disable NMIs so this can deadlock.
> 
> You likely want to use trylock here....

I see. I'll rewrite that part of the code using trylock or RCU.

-- 

Cheers,
Mauro
