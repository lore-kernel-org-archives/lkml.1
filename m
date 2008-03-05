Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbYCEC4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbYCEC4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 21:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYCEC4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 21:56:13 -0500
Received: from ozlabs.org ([203.10.76.45]:59110 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbYCEC4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 21:56:12 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 5/5] typesafe: TIMER_INITIALIZER and setup_timer
Date: Wed, 5 Mar 2008 13:55:36 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <200802042311.18762.rusty@rustcorp.com.au> <20080204145736.GX27894@ZenIV.linux.org.uk> <200802051441.53844.rusty@rustcorp.com.au>
In-Reply-To: <200802051441.53844.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051355.36502.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008 14:41:53 Rusty Russell wrote:
> On Tuesday 05 February 2008 01:57:37 Al Viro wrote:
> > On Mon, Feb 04, 2008 at 11:19:44PM +1100, Rusty Russell wrote:
> > > This patch lets timer callback functions have their natural type
> > > (ie. exactly match the data pointer type); it allows the old "unsigned
> > > long data" type as well.
> > >
> > > Downside: if you use the old "unsigned long" callback type, you won't
> > > get a warning if your data is not an unsigned long, due to the cast.
> >
> > No.  There's much saner way to do that and it does not involve any
> > gccisms at all.  I'd posted such patches quite a while ago; normal C
> > constructs are quite sufficient, TYVM.
>
> If you're referring to your 1 Dec 2006 posting, it was enlightening, but I
> was unable to find any patches.

No reply?  I'll try again now.

> > No.  There's much saner way to do that and it does not involve any
> > gccisms at all.

Except typeof, you mean?

> > I'd posted such patches quite a while ago

AFAICT you posted an untested code fragment which won't actually compile 
because the callback in this case returns void.

> > ; normal C constructs are quite sufficient, TYVM.

Your code didn't check the return type, except that it's a pointer or 
int-compatible.  We can do better, as this patch showed.

If you have a "saner way" of doing this in general which is just as effective, 
I look forward to it.  Otherwise you're just managed to delay these 
improvements for another release.

Rusty.
