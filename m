Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbYDPRMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbYDPRMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYDPRMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:12:37 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55323 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbYDPRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:12:36 -0400
Date: Wed, 16 Apr 2008 10:08:49 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Oliver Neukum <oliver@neukum.org>, Ingo Oeser <ioe-lkml@rameria.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080416100849.01a742aa@laptopd505.fenrus.org>
In-Reply-To: <20080416165811.GO9191@parisc-linux.org>
References: <4803AD91.5020001@firstfloor.org>
	<200804161807.25582.ioe-lkml@rameria.de>
	<20080416161652.GK9191@parisc-linux.org>
	<200804161831.10510.oliver@neukum.org>
	<20080416095026.658bdd21@laptopd505.fenrus.org>
	<20080416165811.GO9191@parisc-linux.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 10:58:11 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Apr 16, 2008 at 09:50:26AM -0700, Arjan van de Ven wrote:
> > yup. For kcounters there is a clear owner for each "slot".
> > [This is the part that makes it debugable again)
> > 
> > Now for non-debug builds, the space taken for the token can be..
> > zero depending on how we define the types for it.
> 
> Hm.  That might be worth changing the API for.  Right now, I'm
> overloading the return value of kcounter_claim with an errno and a
> cookie.  Maybe we should go for:
> 
> extern int __must_check kcounter_claim(struct kcounter *kc,
> kcounter_cookie_t *resource);
> 
> with the return value being 0 or errno and on success, kcounter_claim
> writes a cookie to 'resource'?

or we return a cookie, and define some sort of "cookie_is_error()" thing

> 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
