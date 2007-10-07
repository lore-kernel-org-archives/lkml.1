Return-Path: <linux-kernel-owner+w=401wt.eu-S1755595AbXJGRr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755595AbXJGRr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 13:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbXJGRrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 13:47:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42037 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbXJGRrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 13:47:51 -0400
Date: Sun, 7 Oct 2007 10:46:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: lockdep: how to tell it multiple pte locks is OK?
Message-ID: <20071007104658.655565e3@laptopd505.fenrus.org>
In-Reply-To: <C2543D65-1241-47E6-8C06-BF6E4F73E19A@goop.org>
References: <47087D45.2010904@goop.org>
	<20071007095853.13a8755d@laptopd505.fenrus.org>
	<C2543D65-1241-47E6-8C06-BF6E4F73E19A@goop.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2007 10:17:47 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> 
> On Oct 7, 2007, at 9:58 AM, Arjan van de Ven wrote:
> 
> > On Sat, 06 Oct 2007 23:31:33 -0700
> >
> >> I'm presume I'm the first person to try holding multiple pte locks
> >> at once, so there's no existing locking order for these locks.  I'm
> >> always traversing and locking the pagetable in virtual address
> >> order (and this seems like a sane-enough rule for anyone else who
> >> wants to hold multiple pte locks).
> >
> > I'm not sure that's a valid assumption in light of things like
> > sharing pagetables between processes etc etc..
> > (granted, that one is out of tree right now but I still hope it'll
> > go in some day:)
> 
> Well, yes, but that will take some thought about how split pte locks  
> will work anyway (or more specifically, fork will probably just end  
> up reusing the pte pages and avoid the need to do any
> cross-pagetable pte locking anyway, though I guess that will be
> deferred to COW handling).
> 
> So are you saying I should pass up the opportunity to optimise a  
> relatively hot path (fork/exec/exit) because it will need some  
> further thought if/when shared ptes get implemented? 

s/implemented/merged/ :)

IN fact shared pagetables are already there for hugepages.
For small pages it's a patch at this point.

> Doesn't seem  
> like a good tradeoff...

no I'm not saying that. I'm just saying that I'm worried about the
locking robustness of your trick in general.
