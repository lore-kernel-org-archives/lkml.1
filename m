Return-Path: <linux-kernel-owner+w=401wt.eu-S1752587AbZLMShs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587AbZLMShs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 13:37:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZLMShr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 13:37:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:47891 "HELO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751918AbZLMShq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 13:37:46 -0500
Date: Sun, 13 Dec 2009 19:37:41 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
Subject: Re: [PATCH 0/1] RFC: new kqueue API
Message-ID: <20091213183741.GB18989@one.firstfloor.org>
References: <1260700633.17424.18.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260700633.17424.18.camel@wall-e>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 11:37:13AM +0100, Stefani Seibold wrote:
> As i figured out during the port the old kfifo API users, most of them
> did not need a streamed fifo, because there work only with fixed size
> entries. The kfifo is oversized for this kind of users, so i decided to
> write a new kqueue API which is optimized for fixed size entries. 
> 
> There are a some benefits:
> 
> - Performance (a put or get of an integer does only generate 4 assembly
> instructions on a x86) 
> - Type save
> - Cleaner interface
> - Easier to use
> - Less error prone
> - Smaller footprint
> 
> The API is similar to the new kfifo API, but there is no need for a
> length paramter, because the size of the entry is know by the queue
> structure.

I must say I'm a bit sceptical if the advantages are really worth
the additional code. That code would be always compiled in in addition
to kfifo, so at least the code footprint would be always larger.

Perhaps you could get the advantages for type-safety using
inline wrappers to kfifo?

-Andi
