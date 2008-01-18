Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbYARW3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbYARW3t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 17:29:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932704AbYARW3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 17:29:23 -0500
Received: from smtp.ono.com ([62.42.230.12]:16642 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932683AbYARW3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 17:29:21 -0500
Date: Fri, 18 Jan 2008 23:29:11 +0100
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118232911.22c9d8d5@werewolf>
In-Reply-To: <20080118172428.GB61848@dspnet.fr.eu.org>
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com>
	<alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org>
	<47905A95.4030500@cateee.net>
	<47906133.6010301@cateee.net>
	<4790AF68.8040403@myrealbox.com>
	<20080118172428.GB61848@dspnet.fr.eu.org>
X-Mailer: Claws Mail 3.2.0cvs44 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2008 18:24:29 +0100, Olivier Galibert <galibert@pobox.com> wrote:

> On Fri, Jan 18, 2008 at 08:53:44AM -0500, Andy Lutomirski wrote:
> > I'd say this implies the exact opposite.  It almost sounds like the 
> > compiler is free to change:
> > 
> > void foo(const int *x);
> > foo(x);
> > printf("%d", x);
> > 
> > to:
> > 
> > void foo(const int *x);
> > printf("%d", x);
> > foo(x);
> 
> That's only if neither function has side effects noticeable by the
> other.  Invalidating the pointer in (k)free is rather noticeable.
> 

That's what __attribute__ ((pure)) is for, but if none of the
functions is pure, the compiler can not be sure about side effects
and can not reorder things. Don't forget that functions can do
anything apart from mangling with their arguments.

And allocator/deallocator functions never can be pure, they must
change global data, the pool of free blocks.

--
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
