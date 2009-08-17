Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZHQJ0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZHQJ0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932187AbZHQJ0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:26:20 -0400
Received: from www84.your-server.de ([213.133.104.84]:38044 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbZHQJ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:26:20 -0400
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
From: Stefani Seibold <stefani@seibold.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
In-Reply-To: <20090817095349.4cf8d3c5@lxorguk.ukuu.org.uk>
References: <1250455161.28540.4.camel@wall-e>
	 <1250455590.28540.10.camel@wall-e>
	 <20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	 <20090816163422.a147a918.akpm@linux-foundation.org>
	 <20090817074820.3585206b@lxorguk.ukuu.org.uk>
	 <1250495182.20837.27.camel@wall-e>
	 <20090817091524.33f99737@lxorguk.ukuu.org.uk>
	 <1250497736.20837.39.camel@wall-e>
	 <20090817095349.4cf8d3c5@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 17 Aug 2009 11:26:20 +0200
Message-Id: <1250501180.25359.12.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 17.08.2009, 09:53 +0100 schrieb Alan Cox:
> > And the spinlock is in most cases useless, because the API works fine if
> > only one reader and one writer is using the fifo. This is the common
> > case.
> 
> That is one good argument for fixing the naming. The USB serial code
> probably can be persuaded to use the  single reader/writer assumption as
> well.
> 
> > If you like it is very easy to add a compatibility layer, which restores
> > the old function names. But for what, only for very few users who
> > depends on it? This will only waste the name space.
> 
> Ooh the tragedy, we are short many things but namespace strangely is not
> one of them. Especially when the names all start kfifo_ and __kfifo_, a
> namespace much in demand by other code.
> 
> I'd rather have the old names, or the new names than some kind of gunge
> middle layer of both. Either choice is better.

The question is: what do you expect? Should i provide a compat layer?
Should i retiring my work? 

Give me a solution for this dilemma. I see at this point no way if you
insist for the spinlock to design a clean interface.

Stefani

