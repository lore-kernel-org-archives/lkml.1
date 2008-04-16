Return-Path: <linux-kernel-owner+w=401wt.eu-S1764957AbYDPQ6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764957AbYDPQ6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbYDPQ63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:58:29 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47973 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760879AbYDPQ62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:58:28 -0400
Date: Wed, 16 Apr 2008 10:58:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Oliver Neukum <oliver@neukum.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080416165811.GO9191@parisc-linux.org>
References: <4803AD91.5020001@firstfloor.org> <200804161807.25582.ioe-lkml@rameria.de> <20080416161652.GK9191@parisc-linux.org> <200804161831.10510.oliver@neukum.org> <20080416095026.658bdd21@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416095026.658bdd21@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 09:50:26AM -0700, Arjan van de Ven wrote:
> yup. For kcounters there is a clear owner for each "slot".
> [This is the part that makes it debugable again)
> 
> Now for non-debug builds, the space taken for the token can be.. zero 
> depending on how we define the types for it.

Hm.  That might be worth changing the API for.  Right now, I'm
overloading the return value of kcounter_claim with an errno and a
cookie.  Maybe we should go for:

extern int __must_check kcounter_claim(struct kcounter *kc, kcounter_cookie_t *resource);

with the return value being 0 or errno and on success, kcounter_claim
writes a cookie to 'resource'?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
