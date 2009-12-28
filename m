Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbZL1UEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbZL1UEV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 15:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZL1UEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 15:04:20 -0500
Received: from www84.your-server.de ([213.133.104.84]:48229 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZL1UEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 15:04:20 -0500
Subject: Re: [PATCH] [0/6] kfifo fixes/improvements
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20091228172651.GE4994@basil.fritz.box>
References: <200912271003.631128760@firstfloor.org>
	 <1261949800.25298.18.camel@wall-e> <20091227233816.GC2399@basil.fritz.box>
	 <1261986136.808.2.camel@wall-e> <20091228145749.GD4994@basil.fritz.box>
	 <1262016510.12656.25.camel@wall-e>  <20091228172651.GE4994@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Dec 2009 21:04:13 +0100
Message-ID: <1262030653.15368.37.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 28.12.2009, 18:26 +0100 schrieb Andi Kleen:
> First having to rely on another large patchkit makes 
> it annoying to develop for this (it's the linux kernel
> equivalent of DLL hell), but ok. I hope the interface
> doesn't change again at least.
> 

The interface hasn't been changed, only the implementation. So it should
be not a big issue for the users of the kfifo API! Programming is
sometimes like evolution. But i think the macro based version is now the
right and best solution which a lot of benefits for the users. 

> > So please draw back this patch, you will get exactly what you want and
> > need in the next release. I have now a clean, slim and fast
> > implementation. All what i need is a review and some ack's
> 
> How about the current users for 2.6.33?  Unless they are not 
> record oriented or always put in power-of-two records they will
> need this patch, otherwise they risk desynchronization on fifo
> full.
> 
> I think the patch is needed.
> 

It is exactly the same behavior as the old kfifo API, so no user relies
on the new "kfifo_in atomic" feature. The only user is you. And it is
easy for you to to check if enough room is available with kfifo_avail()
before calling kfifo_in(). That is exactly what your patch do inside the
kfifo_in() function. 

> Also should drop the unused interfaces for 2.6.33 before anyone
> else tries to use them and gets the same nasty surprise as me.
> 

Nasty surprise? Sorry, but i accepted all your patches, excluded one,
which breaks my future work. And i implemented all your suggestions in
my new macro based kfifo API in less than a day. So where is the
problem? You modified the interface not me! Nobody relies currently on
your patches, it's only you.
 
I will send a patch to Andrew for removing kfifo_*_rec() functions if
you like and i hope for your cooperation. Again please draw back your
"kfifo_in atomic" patch. 

And for 2.6.34 everything will be fine :-)

Stefani


