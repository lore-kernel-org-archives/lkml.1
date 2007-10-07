Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXJGRWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXJGRWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 13:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208AbXJGRWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 13:22:00 -0400
Received: from gw.goop.org ([64.81.55.164]:46469 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbXJGRV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 13:21:59 -0400
In-Reply-To: <20071007095853.13a8755d@laptopd505.fenrus.org>
References: <47087D45.2010904@goop.org> <20071007095853.13a8755d@laptopd505.fenrus.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <C2543D65-1241-47E6-8C06-BF6E4F73E19A@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: lockdep: how to tell it multiple pte locks is OK?
Date: Sun, 7 Oct 2007 10:17:47 -0700
To: Arjan van de Ven <arjan@infradead.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 7, 2007, at 9:58 AM, Arjan van de Ven wrote:

> On Sat, 06 Oct 2007 23:31:33 -0700
>
>> I'm presume I'm the first person to try holding multiple pte locks at
>> once, so there's no existing locking order for these locks.  I'm
>> always traversing and locking the pagetable in virtual address order
>> (and this seems like a sane-enough rule for anyone else who wants to
>> hold multiple pte locks).
>
> I'm not sure that's a valid assumption in light of things like sharing
> pagetables between processes etc etc..
> (granted, that one is out of tree right now but I still hope it'll go
> in some day:)

Well, yes, but that will take some thought about how split pte locks  
will work anyway (or more specifically, fork will probably just end  
up reusing the pte pages and avoid the need to do any cross-pagetable  
pte locking anyway, though I guess that will be deferred to COW  
handling).

So are you saying I should pass up the opportunity to optimise a  
relatively hot path (fork/exec/exit) because it will need some  
further thought if/when shared ptes get implemented?  Doesn't seem  
like a good tradeoff...

	J
