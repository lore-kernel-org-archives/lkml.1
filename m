Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZIYMrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZIYMrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 08:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZIYMrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 08:47:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:54356 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZIYMrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 08:47:16 -0400
Date: Fri, 25 Sep 2009 14:47:20 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>,
       bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 17/63] edac_mce: Add an interface driver to report mce
 errors via edac
Message-ID: <20090925144720.38ea1c1f@infradead.org>
In-Reply-To: <20090925091130.14135879@pedra.chehab.org>
References: <20090924192727.212ce46f@pedra.chehab.org>
	<20090925094855.GA29551@aftab>
	<20090925091130.14135879@pedra.chehab.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Sep 2009 09:11:30 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> 5) there are very few calls to kernel routines here:
> list_for_each_entry(), spin_lock_irqsave(), in_unlock_irqrestore(),
> memcpy(). I don't think any of them will have any problems on working
> even inside NMI context.

spinlocks in NMI context don't do what you think they do....
_irqsave does not disable NMIs so this can deadlock.

You likely want to use trylock here....


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
