Return-Path: <linux-kernel-owner+w=401wt.eu-S933997AbXGWXmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbXGWXmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759316AbXGWXm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:42:26 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:28420 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759259AbXGWXmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:42:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g+ZxR1YoH4/368hHg0RJ6dEdzhSffQGl9beMtO+mn4Iy6p0uwO3uOO7ieIa/rzgkQgpTJ5GjxXr94hHGld8YE+gitcVNSjaRmalXM551qFdxgjanBoFgo+q7Ha23xVsVNNFoODGHbS3hF5AcwzJeyaQt0vXFryzHIRTJyqAgU0A=
Message-ID: <e9c3a7c20707231642v711e001k3334f0b974c03ead@mail.gmail.com>
Date: Mon, 23 Jul 2007 16:42:24 -0700
From: "Dan Williams" <dan.j.williams@gmail.com>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: __unsafe() usage
Cc: "Adrian Bunk" <bunk@stusta.de>,
       "Nelson, Shannon" <shannon.nelson@intel.com>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       lksctp-developers@lists.sourceforge.net
In-Reply-To: <1185232601.1803.41.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A3FE3E.20300@googlemail.com>
	 <BAE9DCEF64577A439B3A37F36F9B691C02B820A3@orsmsx418.amr.corp.intel.com>
	 <20070723175927.GM26212@stusta.de>
	 <1185232601.1803.41.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/23/07, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Mon, 2007-07-23 at 19:59 +0200, Adrian Bunk wrote:
> > On Mon, Jul 23, 2007 at 09:05:54AM -0700, Nelson, Shannon wrote:
> > > Gabriel C [mailto:nix.or.die@googlemail.com]
> > > >
> > > >Hi,
> > > >
> > > >I got this warning on current git using gcc 4.2.1 :
> > > >
> > > >...
> > > >
> > > >drivers/dma/ioatdma.c: In function 'ioat_init_module':
> > > >drivers/dma/ioatdma.c:816: warning: the address of
> > > >'__this_module' will always evaluate as 'true'
> > >...
> >
> > I'm less interested in why this gives a warning, more interesting is the
> > code:
> >         __unsafe(THIS_MODULE);
> >
> > @Rusty:
> > As far as I understand it, __unsafe() wasn't intended for such a usage,
> > and simply not providing an exit function would be the right solution?
> > If this is true, and since the MOD_INC_USE_COUNT compat code is long
> > gone, shouldn't we be able to completely remove __unsafe() and the
> > struct member "unsafe"?
>
> Yes, indeed, something like this:
> ==
> Remove "unsafe" from module struct
>
> Adrian Bunk points out that "unsafe" was used to mark modules touched by
> the deprecated MOD_INC_USE_COUNT interface, which has long gone.  It's
> time to remove the member from the module structure, as well.
>
> If you want a module which can't unload, don't register an exit
> function.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Dan Williams <dan.j.williams@intel.com>
