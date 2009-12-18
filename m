Return-Path: <linux-kernel-owner+w=401wt.eu-S932485AbZLRSap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbZLRSap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 13:30:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932343AbZLRSao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 13:30:44 -0500
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3268 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbZLRSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 13:30:43 -0500
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Dec 2009 13:30:43 EST
Subject: Re: spinlock which can morph into a mutex
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.0912181804360.2755@localhost.localdomain>
References: <20091218143032.GA16595@xs4all.net>
	 <alpine.LFD.2.00.0912181804360.2755@localhost.localdomain>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Fri, 18 Dec 2009 19:19:07 +0100
Message-ID: <1261160347.30286.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 18:14 +0100, Thomas Gleixner wrote:
> On Fri, 18 Dec 2009, Miquel van Smoorenburg wrote:
>  I think I need a spinlock that can morph into a mutex ..
> 
> Is the writer frequency and the possible contention so high that you
> need a spinlock at all ?

Possibly - I don't want to degrade the performance of existing code
(which uses a spinlock).
 
> Test it :)

Good point.

> If the mutex is still to heavy weight for you, then you can solve it
> without implementing another weird concurrency control:
> 
>        	  wait_event_(un)interruptible(&hash_wq, !hash_update_active);
>
>        hash_update_active = 1;
>        ....
>        hash_update_active = 0;
>        wake_up(&hash_wq);

Ah, ofcourse. Thanks for pointing that out!

Thanks everybody for your input. I gained quite a bit of insight.

Mike.

