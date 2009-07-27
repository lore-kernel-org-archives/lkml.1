Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZG0Ho1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZG0Ho1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 03:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZG0Ho0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 03:44:26 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49398 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZG0HoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 03:44:19 -0400
Message-ID: <4A6D59B6.3040400@cs.helsinki.fi>
Date: Mon, 27 Jul 2009 10:39:34 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: slqb enables interrupts very early
References: <20090725180321.GA24814@Chamillionaire.breakpoint.cc>
In-Reply-To: <20090725180321.GA24814@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Andrzej Siewior wrote:
> I've checkout slab-2.6/linux-next and noticed that the interrupts are
> enabled very early by accident. Please look at the following call stack:
> 
>     start_kernel()
>     kmem_cache_init()
>     kmem_cache_open()
>     down_write(&slqb_lock);
>     __down_write()
>     __down_write_nested()
> 
> Now, __down_write_nested() protects its internal structure the follwing
> way:
>     spin_lock_irq(&sem->wait_lock);
>     ...
>     spin_unlock_irq(&sem->wait_lock);
> 
> so once we return, we return with interrupts on.

Indeed. Nick, do we need to take ->slqb_lock in kmem_cache_open()? A 
quick read on the code suggests that we could just drop it.

			Pekka
