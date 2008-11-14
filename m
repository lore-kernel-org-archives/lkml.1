Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbYKNVVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbYKNVVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYKNVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:21:10 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37981 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751447AbYKNVVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:21:09 -0500
Date: Fri, 14 Nov 2008 21:21:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rml@tech9.net,
       Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Subject: Re: Active waiting with yield()
Message-ID: <20081114212102.2313a8a3@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0811141327100.22830@hs20-bc2-1.build.redhat.com>
	<20081114190616.30dd273e@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.64.0811141412290.12992@hs20-bc2-1.build.redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If I have a race condition that gets triggered just for one user in the 
> world when repeatedly loading & unloading a driver for an hour, and I use 
> yield() to solve it, what's wrong with it? A wait queue increases cache 
> footprint for every user. (even if I use preallocated hashed wait queue, 
> it still eats a cacheline to access it and find out that it's empty)

Reread what I wrote.

You don't need to use a hashed queue, you don't need to even reference
the queue in the normal case. You cost is one variable, which you can
probably sensibly locate, and a predicted jump.

For that you get proper sleeping behaviour, CPU used by other tasks or
guests and you don't hang on hard real time tasks.
