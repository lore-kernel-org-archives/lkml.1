Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZLNJ7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZLNJ7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 04:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134AbZLNJ7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 04:59:44 -0500
Received: from www84.your-server.de ([213.133.104.84]:57433 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbZLNJ7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 04:59:43 -0500
Subject: Re: [PATCH 0/1] RFC: new kqueue API
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       Joe Perches <joe@perches.com>, Roger Quadros <quadros.roger@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>
In-Reply-To: <20091213183741.GB18989@one.firstfloor.org>
References: <1260700633.17424.18.camel@wall-e>
	 <20091213183741.GB18989@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 14 Dec 2009 10:59:18 +0100
Message-ID: <1260784758.19963.6.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, den 13.12.2009, 19:37 +0100 schrieb Andi Kleen:
> On Sun, Dec 13, 2009 at 11:37:13AM +0100, Stefani Seibold wrote:
> > As i figured out during the port the old kfifo API users, most of them
> > did not need a streamed fifo, because there work only with fixed size
> > entries. The kfifo is oversized for this kind of users, so i decided to
> > write a new kqueue API which is optimized for fixed size entries. 
> > 
> > There are a some benefits:
> > 
> > - Performance (a put or get of an integer does only generate 4 assembly
> > instructions on a x86) 
> > - Type save
> > - Cleaner interface
> > - Easier to use
> > - Less error prone
> > - Smaller footprint
> > 
> > The API is similar to the new kfifo API, but there is no need for a
> > length paramter, because the size of the entry is know by the queue
> > structure.
> 
> I must say I'm a bit sceptical if the advantages are really worth
> the additional code. That code would be always compiled in in addition
> to kfifo, so at least the code footprint would be always larger.
> 
> Perhaps you could get the advantages for type-safety using
> inline wrappers to kfifo?
> 

Okay, i found a nice solution to mix the new kqueue with my kfifo API. 

- It its now type safe and the huger functions are now deinlined. 
- Non dynamic allocated fifo did not need anymore the extra indirection
to the data buffer.
- And i moved the record stuff in an extra header and source file named
kfiforec.[ch].

Stefani





