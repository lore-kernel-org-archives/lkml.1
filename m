Return-Path: <linux-kernel-owner+w=401wt.eu-S1761891AbXEQVrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761891AbXEQVrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbXEQVr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:47:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56586 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbXEQVr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:47:26 -0400
Date: Thu, 17 May 2007 22:47:19 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: dmitry.torokhov@gmail.com, akpm@linux-foundation.org,
       dedekind@infradead.org, linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] ubi: kill homegrown endian macros
Message-ID: <20070517214719.GW4095@ftp.linux.org.uk>
References: <20070517102931.6bbbad1a.akpm@linux-foundation.org> <20070517204234.GR4095@ftp.linux.org.uk> <d120d5000705171414u55af4c03m6e6d2fbcf982e3ff@mail.gmail.com> <20070517.143334.38710608.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517.143334.38710608.davem@davemloft.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 02:33:34PM -0700, David Miller wrote:
> From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> Date: Thu, 17 May 2007 17:14:26 -0400
> 
> > On 5/17/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> > >
> > > Ahem...  So what does
> > >        x |= y;
> > > turns into with that approach?
> > 
> > Do we want to do such kind of operations on endian-annotated data? I'd
> > imagine you want to convert ot host-endianess first anyway.
> 
> Generally you don't, if 'x' and 'y' are both in the needed
> endinaness already, there is no reason to convert anything.

BTW, if you have two independently defined bitwise types, sparse
will complain about mixing them, so you still have protection against
mixing unrelated types that happen to have the same endianness.

Folks, just doing annotations of net/* had been large enough and it
mostly had been about annotating declarations.  If we have to rewrite
every sodding place where we happen to do bitwise operations on those...
Forget about it.  BTW, another fun kind of places is comparing for
equality - also adds a fsckload of lines to rewrite^Wobscure.
