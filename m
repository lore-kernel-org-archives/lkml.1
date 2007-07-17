Return-Path: <linux-kernel-owner+w=401wt.eu-S936415AbXGQUtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936415AbXGQUtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:49:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936337AbXGQUp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:45:26 -0400
Received: from 1wt.eu ([62.212.114.60]:3422 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936362AbXGQUpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:45:24 -0400
Date: Tue, 17 Jul 2007 22:41:57 +0200
From: Willy Tarreau <w@1wt.eu>
To: Tony Borras <tonyb@sysdev.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 2.4.35 tree abandoned/delayed?
Message-ID: <20070717204155.GE943@1wt.eu>
References: <8HJqo-2BV-23@gated-at.bofh.it> <8HJqo-2BV-21@gated-at.bofh.it> <8HNDE-JM-11@gated-at.bofh.it> <20070716232357.3d9e5ca7.tonyb@sysdev.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716232357.3d9e5ca7.tonyb@sysdev.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

[ first, please always keep people in CC on LKML since it's very easy to
  miss a thread ]

On Mon, Jul 16, 2007 at 11:23:57PM -0800, Tony Borras wrote:
> On Tue, 17 Jul 2007 07:20:06 +0200
> Willy Tarreau <w@1wt.eu> wrote:
> 
> > could you please report what the problem was, in case it's not
> > fixed yet ?
> 
> Ok, reproduced error at ./net/ipv4/fib_semantics.c
>   line 436 changed label:
>                    errout -> err_inval

I don't know where you downloaded 2.4.35-pre5 from, but I've checked the
sources and could not find any reference to "errout" here in any version!

Or what is possible is that your 2.4.34 kernel got corrupted on your disk
after applying any patch. Sometimes, some shell scripts providede with some
drivers directly tamper with the sources. You should check that your tree
is valid by downloading another one and comparing them.

It had already happened to me in the past and I got 3 or 4 private kernels
with a fix that I did not know I had applied. Fortunately, this does not
happen anymore with git ;-)

> then it builds fine!
> 
> started with linux-2.4.34
> then patched
>      patch-2.4.34.1
>      patch-2.4.34.2
>      patch-2.4.34.3
>      patch-2.4.34.4
>      patch-2.4.34.5
>      patch-2.4.35.pre5

Huh !!! You should not apply all 2.4.34 patches before 2.4.35. You should
see the development process like this :

---> 2.4.34 ----> 2.4.35-pre1 ----> 2.4.35-pre2 ---> ... ---> 2.4.35
       \
        `--> 2.4.34.1 --> 2.4.34.2 --> 2.4.34.3 ...

So 2.4.35-preX and 2.4.34.X are two different branches forked from 2.4.34.
All 2.4.35-preX patches are made for 2.4.34, and all 2.4.34.X patches are
made for 2.4.34 too.

You should see 2.4.34 as the real official kernel, and other ones as
convenience versions released in order to help people keep up to date
without having to use possibly buggy pre-releases, even if they are
quite close.

> I used a make oldconfig on a .config that builds in 2.4.34
> 
> Hope that helps
> TonyB

Thanks anyway for your feedback !

Regards,
Willy

